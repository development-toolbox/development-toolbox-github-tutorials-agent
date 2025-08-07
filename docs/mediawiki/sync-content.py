#!/usr/bin/env python3
"""
MediaWiki Content Sync Script

This script synchronizes content from your local files to MediaWiki pages.
It watches for changes in your content folder and automatically updates MediaWiki.
"""

import os
import sys
import requests
import json
import time
import hashlib
from pathlib import Path
from typing import Dict, Optional
import argparse
from datetime import datetime

class MediaWikiSync:
    def __init__(self, wiki_url: str, username: str, password: str):
        self.wiki_url = wiki_url.rstrip('/')
        self.api_url = f"{self.wiki_url}/api.php"
        self.username = username
        self.password = password
        self.session = requests.Session()
        self.csrf_token = None
        self.content_hashes = {}
        
    def login(self) -> bool:
        """Login to MediaWiki and get CSRF token"""
        print(f"🔐 Logging into MediaWiki at {self.wiki_url}")
        
        # Get login token
        response = self.session.post(self.api_url, data={
            'action': 'query',
            'meta': 'tokens',
            'type': 'login',
            'format': 'json'
        })
        
        if response.status_code != 200:
            print(f"❌ Failed to get login token: {response.status_code}")
            return False
            
        data = response.json()
        if 'error' in data:
            print(f"❌ Login token error: {data['error']}")
            return False
            
        login_token = data['query']['tokens']['logintoken']
        
        # Login
        response = self.session.post(self.api_url, data={
            'action': 'login',
            'lgname': self.username,
            'lgpassword': self.password,
            'lgtoken': login_token,
            'format': 'json'
        })
        
        if response.status_code != 200:
            print(f"❌ Login failed: {response.status_code}")
            return False
            
        data = response.json()
        if data['login']['result'] != 'Success':
            print(f"❌ Login failed: {data['login']['result']}")
            return False
            
        print("✅ Successfully logged in")
        
        # Get CSRF token for editing
        response = self.session.post(self.api_url, data={
            'action': 'query',
            'meta': 'tokens',
            'format': 'json'
        })
        
        if response.status_code == 200:
            data = response.json()
            self.csrf_token = data['query']['tokens']['csrftoken']
            print("✅ CSRF token obtained")
            return True
        else:
            print("❌ Failed to get CSRF token")
            return False
    
    def get_file_hash(self, file_path: str) -> str:
        """Get MD5 hash of file content"""
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        return hashlib.md5(content.encode('utf-8')).hexdigest()
    
    def get_page_title_from_filename(self, filename: str) -> str:
        """Convert filename to MediaWiki page title"""
        # Remove .mediawiki extension
        title = filename.replace('.mediawiki', '')
        # Replace underscores with spaces
        title = title.replace('_', ' ')
        return title
    
    def update_page(self, title: str, content: str, summary: str = "Updated via sync script") -> bool:
        """Update or create a MediaWiki page"""
        print(f"📝 Updating page: {title}")
        
        response = self.session.post(self.api_url, data={
            'action': 'edit',
            'title': title,
            'text': content,
            'summary': summary,
            'token': self.csrf_token,
            'format': 'json'
        })
        
        if response.status_code != 200:
            print(f"❌ Failed to update {title}: {response.status_code}")
            return False
            
        data = response.json()
        if 'error' in data:
            print(f"❌ Error updating {title}: {data['error']['info']}")
            return False
            
        if 'edit' in data and data['edit']['result'] == 'Success':
            print(f"✅ Successfully updated: {title}")
            return True
        else:
            print(f"❌ Unknown error updating {title}: {data}")
            return False
    
    def sync_file(self, file_path: str, force: bool = False) -> bool:
        """Sync a single file to MediaWiki"""
        if not os.path.exists(file_path):
            print(f"❌ File not found: {file_path}")
            return False
        
        # Check if file has changed (unless force sync)
        current_hash = self.get_file_hash(file_path)
        if not force and file_path in self.content_hashes:
            if self.content_hashes[file_path] == current_hash:
                return True  # No changes, skip
        
        # Read content
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Get page title
        filename = os.path.basename(file_path)
        title = self.get_page_title_from_filename(filename)
        
        # Update page
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        summary = f"Synced from {filename} at {timestamp}"
        
        if self.update_page(title, content, summary):
            self.content_hashes[file_path] = current_hash
            return True
        else:
            return False
    
    def sync_directory(self, content_dir: str, force: bool = False) -> Dict[str, bool]:
        """Sync all .mediawiki files in a directory"""
        results = {}
        content_path = Path(content_dir)
        
        if not content_path.exists():
            print(f"❌ Content directory not found: {content_dir}")
            return results
        
        print(f"📁 Syncing content from: {content_dir}")
        
        # Find all .mediawiki files
        mediawiki_files = list(content_path.glob("**/*.mediawiki"))
        
        if not mediawiki_files:
            print("⚠️  No .mediawiki files found in content directory")
            return results
        
        print(f"📄 Found {len(mediawiki_files)} files to sync")
        
        # Sync each file
        for file_path in mediawiki_files:
            file_str = str(file_path)
            try:
                results[file_str] = self.sync_file(file_str, force)
            except Exception as e:
                print(f"❌ Error syncing {file_str}: {e}")
                results[file_str] = False
        
        return results
    
    def watch_directory(self, content_dir: str, interval: int = 5):
        """Watch directory for changes and sync automatically"""
        print(f"👀 Watching {content_dir} for changes (checking every {interval}s)")
        print("Press Ctrl+C to stop watching...")
        
        try:
            while True:
                results = self.sync_directory(content_dir)
                updated_count = sum(1 for success in results.values() if success)
                
                if updated_count > 0:
                    print(f"🔄 Synced {updated_count} files at {datetime.now().strftime('%H:%M:%S')}")
                
                time.sleep(interval)
                
        except KeyboardInterrupt:
            print("\n⏹️  Stopped watching for changes")

def main():
    parser = argparse.ArgumentParser(description='Sync MediaWiki content from local files')
    parser.add_argument('--url', required=True, help='MediaWiki URL (e.g., http://localhost:8080)')
    parser.add_argument('--username', required=True, help='MediaWiki username')
    parser.add_argument('--password', required=True, help='MediaWiki password')
    parser.add_argument('--content-dir', default='internal-wiki/content', help='Content directory path')
    parser.add_argument('--watch', action='store_true', help='Watch for changes and auto-sync')
    parser.add_argument('--interval', type=int, default=5, help='Watch interval in seconds')
    parser.add_argument('--force', action='store_true', help='Force sync all files regardless of changes')
    parser.add_argument('--file', help='Sync a specific file instead of entire directory')
    
    args = parser.parse_args()
    
    # Create sync instance
    sync = MediaWikiSync(args.url, args.username, args.password)
    
    # Login
    if not sync.login():
        sys.exit(1)
    
    try:
        if args.file:
            # Sync specific file
            print(f"📄 Syncing single file: {args.file}")
            success = sync.sync_file(args.file, args.force)
            if success:
                print("✅ File sync completed successfully")
            else:
                print("❌ File sync failed")
                sys.exit(1)
                
        elif args.watch:
            # Watch mode
            sync.watch_directory(args.content_dir, args.interval)
            
        else:
            # One-time sync
            results = sync.sync_directory(args.content_dir, args.force)
            
            # Print summary
            total_files = len(results)
            successful = sum(1 for success in results.values() if success)
            failed = total_files - successful
            
            print(f"\n📊 Sync Summary:")
            print(f"   ✅ Successful: {successful}")
            print(f"   ❌ Failed: {failed}")
            print(f"   📁 Total: {total_files}")
            
            if failed > 0:
                print(f"\n❌ Failed files:")
                for file_path, success in results.items():
                    if not success:
                        print(f"   - {file_path}")
                sys.exit(1)
            else:
                print(f"\n🎉 All files synced successfully!")
    
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()