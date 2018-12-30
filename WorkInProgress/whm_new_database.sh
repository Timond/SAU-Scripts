#cpuser='cpanel_username'
#dbname='database_name'
#dbuser='database_user_name'
#password='url_encoded_password_string'
#privstring='comma, separated, privilege, string'

echo Please enter the cPanel username:
read cpuser
echo Please enter the new database name:
read dbname
echo Please enter the new database username:
read dbuser
echo Please enter the new database password:
read password

echo cPanel username: $cpuser
echo New DB user: $dbuser
echo New database name: $dbname
echo New database password: $password

echo Is this correct? Y/N
read answer

uapi --user=$cpuser Mysql create_database name=$dbname;
uapi --user=$cpuser Mysql create_user name=$dbuser password=$password;
uapi --user=$cpuser Mysql set_password user=$dbuser password=$password;
uapi --user=$cpuser Mysql set_privileges_on_database user=$dbuser database=$dbname privileges=$privstring;
