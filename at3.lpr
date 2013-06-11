program at3;

uses
  md5, Crt, Sysutils;

var
  uUserName, uFullName, uAddress, uPhone, uLicense : text;
  UserInfo : array of array of string;
  DVDInfo : array[0..1, 0..1] of string;
  linecount : integer;
  count : integer;
  loggedin, exitflag : boolean;
  menuoption : char;
  usernums : integer;

  //these are for reading and writing users
  tempuser : string;
  tempname : string;
  templicense : string;
  tempaddress : string;
  tempphone : string;
  tempdata : array[1..5] of string;

  //these are for the DVDs (also uses tempname)
  tempgenre : string;
  tempyear : string;


Procedure Login_System;
Var
  usernames, passwords : text;
  usermatch, passmatch : boolean;
  inputname, inputpass, passhash, temppass : string;
  count : integer;
Begin
     clrscr;


     //This checks for the username
     If (FileExists('c:\Data\DVD_Database\usernames.txt') = true) AND (FileExists('c:\Data\DVD_Database\passwords.txt') = true) then
     begin
          usermatch := false;
          passmatch:= false;
          Writeln('Please enter your username and hit enter.');
          Readln(inputname);
          Writeln('Please enter your password and hit enter.');
          Readln(inputpass);
          Assign(usernames, 'c:\Data\DVD_Database\usernames.txt');
          Assign(passwords, 'c:\Data\DVD_Database\passwords.txt');
          reset(usernames);
          reset(passwords);
          linecount := 0;
          While (EOF(usernames) = false) AND (usermatch = false) do
          begin
               linecount := linecount + 1;
               readln(usernames, tempuser);
               If inputname = tempuser then
               begin
                    usermatch := true;
               end;
          end;

          //this section will check the password if the username matches
          if usermatch = true then
          begin
                 inputpass := inputpass + inputname; //this is the salt for the hash generation
                 passhash := MD5Print(MD5String(inputpass));  //this generates the md5 hash
                 While count <= linecount do
                 begin
                      readln(passwords, temppass);
                      if count = linecount then
                      begin
                           if temppass = passhash then
                           begin
                                passmatch := true;
                           end;
                      end;
                 end;
          end;
          If (usermatch = true) AND (passmatch = true) then
          begin
               loggedin := true;
          end;
     end
     else
     begin
         writeln('There are no users, please create an account');
         readln
     end;
end;

Procedure LoadData;
var
    count : integer;

Begin
     loggedin := false;
     If Not DirectoryExists('c:\Data\') then
     begin
          createdir('c:\Data\');
     end;
     If Not DirectoryExists('c:\Data\DVD_Database\') then
     begin
          createdir('c:\Data\DVD_Database\');
     end;
     If Not DirectoryExists('c:\Data\DVD_Database\userdata\') then
     begin
          createdir('c:\Data\DVD_Database\userdata\');
     end;
     Assign(uUserName, 'c:\Data\DVD_Database\usernames.txt');
     Assign(uFullName, 'c:\Data\DVD_Database\userdata\names.txt');
     Assign(uAddress, 'c:\Data\DVD_Database\userdata\address.txt');
     Assign(uPhone, 'c:\Data\DVD_Database\userdata\phones.txt');
     Assign(uLicense, 'c:\Data\DVD_Database\userdata\license.txt');
     If (FileExists('c:\Data\DVD_Database\userdata.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\names.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\address.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\phones.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\license.txt') = true) then
     begin
          reset(uUserName);
          reset(uFullName);
          reset(uAddress);
          reset(uPhone);
          reset(uLicense);
          count := 0;
          While not EOF(uUsername) do
          begin
              SetLength(UserInfo, (count + 1), 5);
              count := count + 1;
              readln(uUserName, UserInfo[count, 1]);
              readln(uFullName, UserInfo[count, 2]);
              readln(uAddress, UserInfo[count, 3]);
              readln(uPhone, UserInfo[count, 4]);
              readln(uLicense, UserInfo[count, 5]);
              usernums := count;
          end;
     end;
end;

Procedure ExitProgram;
var
  count : integer;

begin
     Assign(uUserName, 'c:\Data\DVD_Database\usernames.txt');
     Assign(uFullName, 'c:\Data\DVD_Database\userdata\names.txt');
     Assign(uAddress, 'c:\Data\DVD_Database\userdata\address.txt');
     Assign(uPhone, 'c:\Data\DVD_Database\userdata\phones.txt');
     Assign(uLicense, 'c:\Data\DVD_Database\userdata\license.txt');
     If (FileExists('c:\Data\DVD_Database\userdata.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\names.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\address.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\phones.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\license.txt') = true) then
          append(uUserName)
     else
          rewrite(uUserName);
          rewrite(uFullName);
          rewrite(uAddress);
          rewrite(uPhone);
          rewrite(uLicense);
     for count := 1 to usernums do
     begin
         writeln(uUserName, UserInfo[count, 1]);
         writeln(uFullName, UserInfo[count, 2]);
         writeln(uAddress, UserInfo[count, 3]);
         writeln(uPhone, UserInfo[count, 4]);
         writeln(uLicense, UserInfo[count, 5]);
     end;
     exitflag := true
end;



Procedure CreateAccount;
Var
  userflag : boolean;

Begin

     userflag := false;
     while userflag = false do
     begin
          userflag := true;
          clrscr;
          Writeln('Please enter your desired username');
          Write('>>> ');
          readln(tempuser);
          For count := 1 to usernums do
          begin
               if tempuser = userinfo[count, 1] then
               begin
                    Writeln('Sorry, that username is taken, please choose another.');
                    userflag := false;
               end;
          end;
     end;
     Writeln('Please enter your full name.');
     Write('>>> ');
     readln(tempname);
     Writeln('Please enter your address.');
     Write('>>> ');
     readln(tempaddress);
     Writeln('Please enter your license number.');
     Write('>>> ');
     readln(templicense);
     Writeln('Please enter your phone number.');
     Write('>>> ');
     readln(tempphone);
end;

begin
  LoadData;
  While loggedin = false do
  begin
       clrscr;
       Writeln('Welcome to Ms Lasers DVD rental system!');
       Writeln('1. Login');
       Writeln('2. Create Account');
       Writeln('3. Exit');
       Writeln('Please select an option by typing 1, 2 or 3 and hitting enter.');
       Write('>>> ');
       readln(menuoption);
       Case menuoption of
            '1' : Begin
                Login_System;
            end;
            '2' : Begin
                createaccount;
            end;
            '3' : Begin
                exitprogram;
                exit
            end;
            else
              begin
                  clrscr;
                  Writeln('Please enter a number between 1 and 3');
                  readln;
              end;
       end;
  end;
end.


