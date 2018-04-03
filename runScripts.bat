echo off
for /r %%v in (*.sql) do sqlcmd -E -S sqlServerConnectionName -i "%%v"