import os
from ftplib import FTP

# Define the FTP server details
ftp_server = 'domain.ftp.com.'
ftp_user = 'yekta'
ftp_pass = 'yektapass'
ftp_dir = '/documents/data'

# Define the local directory where files will be downloaded to
local_dir = './downloads/'

# Connect to the FTP server
ftp = FTP(ftp_server)
ftp.login(user=ftp_user, passwd=ftp_pass)

# Change to the directory where the files are located
ftp.cwd(ftp_dir)

# Get a list of files in the current directory
file_list = ftp.nlst()

# Download each file to the local directory
for file_name in file_list:
    local_file = os.path.join(local_dir, file_name)
    with open(local_file, 'wb') as f:
        ftp.retrbinary('RETR %s' % file_name, f.write)

# Close the FTP connection
ftp.quit()
