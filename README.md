# Simple MySQL Database Backup Script
A simple script to backup all local mysql databases.

- ✅ If MYSQL_USER and MYSQL_PASS are set in the script, it uses them (for automation/cron).
- ✅ If they’re left blank, the script prompts interactively (for manual use).
- ✅ Creates a backup directory using current date and time
- ✅ Exports each database into a separate .sql file inside that folder
- ✅ Compresses the entire backup folder into a .tar.gz archive
- ✅ Optionally deletes the uncompressed folder after compression (commented out for safety)
