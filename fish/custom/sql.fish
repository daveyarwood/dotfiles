set -l mssql_tools_dir /opt/mssql-tools/bin

if test -d $mssql_tools_dir
  set -gx PATH $mssql_tools_dir $PATH
end

