program at3;

uses
  md5, Crt, Sysutils;

var
  uUserName, uFullName, uAddress, uPhone, uLicense, uDVD: text;
  dName, dGenre, dYear, dRented : text;
  UserInfo : array of array of string;
  UserDVD : array of integer;
  DVDInfo : array of array of string;
  DVDrented : array of boolean;
  usernames, passwords : text;
  linecount : integer;
  userid : integer;
  count : integer;
  loggedin, exitflag : boolean;
  menuoption : char;
  usernums, DVDnums: integer;
  currentuser : string;
  currentdata : array[1..5] of string;
  searchterm : integer;
  inputdvd : string;
  menuchosen, displayflag : boolean;
  dvdindex : integer;
  price, total : real;
  weeks : integer;

  //these are for reading and writing users
  tempuser : string;
  tempname : string;
  templicense : string;
  tempaddress : string;
  tempphone : string;
  temppass : string;


  //these are for the DVDs (also uses tempname)
  tempgenre : string;
  tempyear : string;


Procedure DisplayDVD;
begin
   displayflag := true;
   while displayflag = true do
   begin
       clrscr;
       Writeln('Name: ', DVDinfo[dvdindex, 1]);
       Writeln('    Genre: ', DVDinfo[dvdindex, 2]);
       Writeln('     Year: ', DVDinfo[dvdindex, 3]);
       Writeln('   Rented: ', DVDRented[dvdindex]);
       Writeln;
       Writeln('Would you like to');
       Writeln('1. Rent this DVD');
       Writeln('2. Exit');
       Writeln('Please select an option by typing 1 or 2 and hitting enter.');
       Write('>>> ');
       readln(menuoption);
       Case menuoption of
            '1' : Begin
                clrscr;
                if DVDRented[dvdindex] = true then
                begin
                    writeln('Sorry, that DVD is rented');
                    readln;
                end
                else
                begin
                    DVDRented[dvdindex] := true;
                    UserDVD[userid] := dvdindex;
                    Writeln('You have rented ', DVDinfo[dvdindex, 1], '. This will cost $',price, ' per week.');
                    readln;
                    displayflag := false;
                end;
            end;
            '2' : Begin
                displayflag := false;
            end;
            else
              begin
                  clrscr;
                  Writeln('Please enter 1 or 2');
                  readln;
              end;
       end;

   end;
end;

Function DVDSearch(term: string) : integer;
  var
    dmax, dmin : string;
    max, min, mid : integer;
    found : boolean;
  begin
       found := false;
       max := dvdnums;
       min := 1;
       While (found = false) do
       begin
            mid := trunc((max + min)/2);
            If max = min then
            begin
                 found := true;
                 DVDSearch := 0;
                 Writeln('Sorry, but that DVD was not found');
            end;
            if term = DVDinfo[mid, 1] then
            begin
                 DVDSearch := mid;
                 found := true;
            end
            else if term < DVDinfo[mid, 1] then
                 max := mid
            else
                min := mid;
       end;

  end;

Procedure DeleteDVD;
    var
      index : integer;
    begin
         clrscr;
         writeln('Please enter the name of the DVD you wish to delete');
         write('>>> ');
         readln(inputdvd);
         index := DVDSearch(inputdvd);

         for count := index to (dvdnums - 1) do
         begin
              DVDinfo[count, 1] := DVDinfo[count + 1, 1];  //deletes DVD
              DVDRented[count] := DVDRented[(count +1)]
         end;
         SetLength(DVDinfo, (dvdnums + 1), 4);   //decreases size of array
         SetLength(DVDRented, (dvdnums + 1));
    end;

Procedure AddDVD;
  begin
       clrscr;
       Writeln('Please enter the name of the DVD.');
       Write('>>> ');
       readln(tempname);
       clrscr;
       Writeln('Please enter the genre of the DVD.');
       Write('>>> ');
       readln(tempgenre);
       clrscr;
       Writeln('Please enter the year of the DVD.');
       Write('>>> ');
       readln(tempyear);

       SetLength(DVDinfo, (dvdnums + 2), 4);  //increases the length of the array
       SetLength(DVDrented, (dvdnums + 2));
       DVDinfo[(dvdnums + 1), 1] := tempname;
       DVDinfo[(dvdnums + 1), 2] := tempgenre;
       DVDinfo[(dvdnums + 1), 3] := tempyear;
       DVDrented[(dvdnums + 1)] := false;

       Assign(dName, 'c:\Data\DVD_Database\DVDdata\DVDnames.txt');
       Assign(dGenre, 'c:\Data\DVD_Database\DVDdata\DVDgenres.txt');
       Assign(dYear, 'c:\Data\DVD_Database\DVDdata\DVDYears.txt');

       append(dName);
       append(dGenre);
       append(dYear);
       writeln(dName, DVDinfo[(dvdnums + 1), 1]);
       writeln(dGenre, DVDinfo[(dvdnums + 1), 2]);
       writeln(dYear, DVDinfo[(dvdnums + 1), 3]);
       close(dName);
       close(dGenre);
       close(dYear);



       dvdnums := dvdnums + 1;      //increases the number of users

       Writeln('DVD added, press any key to continue!');
       readln;

  end;

Procedure ManageDVD;
    begin
           clrscr;
           Writeln('Welcome, Ms Laser!');
           Writeln('1. Add DVD');
           Writeln('2. Delete DVD');
           Writeln('3. Exit');
           Writeln('Please select an option by typing 1, 2 or 3 and hitting enter.');
           Write('>>> ');
           readln(menuoption);
           Case menuoption of
                '1' : Begin
                    AddDVD;
                end;
                '2' : Begin
                    DeleteDVD;
                end;
                '3' : Begin
                end;
                else
                  begin
                      clrscr;
                      Writeln('Please enter a number between 1 and 3');
                      readln;
                  end;
           end;
    end;

Procedure LoadData;

Begin
     loggedin := false; //flag for whether the user is logged in

     //this ensures the directories are created
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
          createdir('c:\Data\DVD_Database\userdata\');                                                                                                                                                                              If (FileExists('c:\Data\DVD_Database\usernames.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\names.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\address.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\phones.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\license.txt') = true) then
     end;


     //assigns the text files to be used
     Assign(uUserName, 'c:\Data\DVD_Database\usernames.txt');
     Assign(uFullName, 'c:\Data\DVD_Database\userdata\names.txt');
     Assign(uAddress, 'c:\Data\DVD_Database\userdata\address.txt');
     Assign(uPhone, 'c:\Data\DVD_Database\userdata\phones.txt');
     Assign(uLicense, 'c:\Data\DVD_Database\userdata\license.txt');
     assign(passwords, 'c:\Data\DVD_Database\passwords.txt');

     If (FileExists('c:\Data\DVD_Database\usernames.txt') = false) OR (FileExists('c:\Data\DVD_Database\userdata\names.txt') = false) OR (FileExists('c:\Data\DVD_Database\userdata\address.txt') = false) OR (FileExists('c:\Data\DVD_Database\userdata\phones.txt') = false) OR (FileExists('c:\Data\DVD_Database\userdata\license.txt') = false) then
          begin
               rewrite(uUserName);
               rewrite(uFullName);
               rewrite(uAddress);
               rewrite(uPhone);
               rewrite(uLicense);
               writeln('making files');
               readln;
               writeln(uUserName, 'admin');          //if the files don't exist, the admin account data is written to file
               writeln(uFullName, 'Ms Laser');       //this way there is always an admin account
               writeln(uAddress, 'N/A');
               writeln(uPhone, 'N/A');
               writeln(uLicense, 'N/A');
               rewrite(passwords);
               writeln(passwords, '80a19f669b02edfbc208a5386ab5036b');
               close(passwords);
          end;

     //If there is previous data
     If (FileExists('c:\Data\DVD_Database\usernames.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\names.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\address.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\phones.txt') = true) AND (FileExists('c:\Data\DVD_Database\userdata\license.txt') = true) then
     begin
          reset(uUserName);
          reset(uFullName);
          reset(uAddress);
          reset(uPhone);
          reset(uLicense);
          count := 0;
          While not EOF(uUsername) do
          begin
              count := count + 1;  //increments count
              SetLength(UserInfo, (count + 1), 6);       //sets the maximum index to count
              readln(uUserName, UserInfo[count, 1]);     //(the setlength command uses 0 centred arrays)
              readln(uFullName, UserInfo[count, 2]);
              readln(uAddress, UserInfo[count, 3]);
              readln(uPhone, UserInfo[count, 4]);
              readln(uLicense, UserInfo[count, 5]);
              usernums := count;  //records number of users
          end;
          close(uUserName);
          close(uFullName);
          close(uAddress);
          close(uPhone);
          close(uLicense);
     end;



     If Not DirectoryExists('c:\Data\DVD_Database\DVDdata\') then
     begin
          createdir('c:\Data\DVD_Database\DVDdata\');
     end;
     count := 0;
     Assign(dName, 'c:\Data\DVD_Database\DVDdata\DVDnames.txt');
     Assign(dGenre, 'c:\Data\DVD_Database\DVDdata\DVDgenres.txt');
     Assign(dYear, 'c:\Data\DVD_Database\DVDdata\DVDYears.txt');
     Assign(dRented, 'c:\Data\DVD_Database\DVDdata\DVDRented.txt');

     If (FileExists('c:\Data\DVD_Database\DVDdata\DVDRented.txt') = true) AND (FileExists('c:\Data\DVD_Database\DVDdata\DVDnames.txt') = true) AND (FileExists('c:\Data\DVD_Database\DVDdata\DVDgenres.txt') = true) AND (FileExists('c:\Data\DVD_Database\DVDdata\DVDYears.txt') = true) then
     begin
          reset(dName);
          reset(dGenre);
          reset(dYear);
          reset(dRented);
          While not EOF(dName) do
          begin
              count := count + 1;  //increments count
              SetLength(DVDInfo, (count + 1), 4);    //sets the maximum index to count
              SetLength(DVDRented, (count + 1));
              readln(dName, DVDinfo[count, 1]);     //(the setlength command uses 0 centred arrays)
              readln(dGenre, DVDinfo[count, 2]);
              readln(dYear, DVDinfo[count, 3]);
              readln(dRented, DVDrented[count]);
              DVDnums := count;  //records number of DVDs
          end;
     end
     else
     begin
          rewrite(dName);
          rewrite(dGenre);
          rewrite(dYear);
          rewrite(dRented);
     end;
     close(dName);
     close(dGenre);
     close(dYear);
     close(dRented);
end;

Procedure ExitProgram;

begin
     Assign(uUserName, 'c:\Data\DVD_Database\usernames.txt');
     Assign(uFullName, 'c:\Data\DVD_Database\userdata\names.txt');
     Assign(uAddress, 'c:\Data\DVD_Database\userdata\address.txt');
     Assign(uPhone, 'c:\Data\DVD_Database\userdata\phones.txt');
     Assign(uLicense, 'c:\Data\DVD_Database\userdata\license.txt');
     Assign(passwords, 'c:\Data\DVD_Database\passwords.txt');
     Assign(uDVD, 'c:\Data\DVD_Database\userdata\rentals.txt');
     begin
          If (FileExists('c:\Data\DVD_Database\userdata\rentals.txt') = false) OR (FileExists('c:\Data\DVD_Database\usernames.txt') = false) OR (FileExists('c:\Data\DVD_Database\userdata\names.txt') = false) OR (FileExists('c:\Data\DVD_Database\userdata\address.txt') = false) OR (FileExists('c:\Data\DVD_Database\userdata\phones.txt') = false) OR (FileExists('c:\Data\DVD_Database\userdata\license.txt') = false) then
          begin
               rewrite(uUserName);
               rewrite(uFullName);
               rewrite(uAddress);
               rewrite(uPhone);
               rewrite(uLicense);
               rewrite(uDVD);
               writeln(uUserName, 'admin');          //if the files don't exist, the admin account data is written to file
               writeln(uFullName, 'Ms Laser');       //this way there is always an admin account
               writeln(uAddress, 'N/A');
               writeln(uPhone, 'N/A');
               writeln(uLicense, 'N/A');
               writeln(uDVD, '0');
               rewrite(passwords);
               writeln(passwords, '80a19f669b02edfbc208a5386ab5036b');
               close(passwords);
          end
          else
          begin
               rewrite(uUserName);
               rewrite(uFullName);
               rewrite(uAddress);
               rewrite(uPhone);
               rewrite(uLicense);
          end;
     end;
     for count := 1 to usernums do
     begin

         //writes the data to the files
         writeln(uUserName, UserInfo[count, 1]);
         writeln(uFullName, UserInfo[count, 2]);
         writeln(uAddress, UserInfo[count, 3]);
         writeln(uPhone, UserInfo[count, 4]);
         writeln(uLicense, UserInfo[count, 5]);
         writeln(uDVD, UserDVD[count]);
     end;
     close(uUserName);
     close(uFullName);
     close(uAddress);
     close(uPhone);
     close(uLicense);
     close(uDVD);

     SetLength(UserInfo, 0, 6); //wipes the user array
     loggedin := false;

     LoadData;


end;

Procedure AdminMenu;
var
  adminloop : boolean;
  begin
         adminloop := false;
         while adminloop = false do
         begin
              clrscr;
              Writeln('Welcome to the admin menu, Ms Laser!');
              Writeln('1. Manage DVDs');
              Writeln('2. Manage Users');
              Writeln('3. Exit admin menu');
              Writeln('Please select an option by typing 1, 2 or 3 and hitting enter.');
              Write('>>> ');
              readln(menuoption);
              Case menuoption of
                   '1' : Begin
                       ManageDVD;
                   end;
                   '2' : Begin
                       //ManageUsers;
                   end;
                   '3' : Begin
                       adminloop := true;
                   end;
                   else
                   begin
                        clrscr;
                        Writeln('Please enter a number between 1 and 3');
                        readln;
                   end;
              end;
         end;

  end;

Procedure Login_System;
Var
  usermatch, passmatch : boolean;
  inputname, inputpass, passhash, temppass : string;
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
               //tempuser := userinfo[linecount, 1];
               If (inputname = tempuser) then
               begin
                    usermatch := true;
                    userid := linecount;
               end;
          end;

          //this section will check the password if the username matches
          if usermatch = true then
          begin
                 inputpass := inputpass + inputname; //this is the salt for the hash generation
                 passhash := MD5Print(MD5String(inputpass));  //this generates the md5 hash
                 count := 0;
                 While (EOF(passwords) = false) AND (passmatch = false) do
                 begin
                      readln(passwords, temppass);
                      if count = (linecount - 1) then
                      begin
                           if temppass = passhash then
                           begin
                                passmatch := true;
                           end;
                      end;
                      count := count + 1;
                 end;
          end;
          If (usermatch = true) AND (passmatch = true) then
          begin
               loggedin := true;
               Writeln('You have logged in as "', inputname, '".');
               currentuser := inputname;
               count := 0;
               count := 0;
               For count := 1 to 5 do
               begin
                    currentdata[count] := userinfo[userid, count];
               end;


               readln;
          end
          else
          begin
               Writeln('Sorry, that username or password is incorrect');
               Readln;
          end;
          close(usernames);
          close(passwords);
     end
     else
     begin
         writeln('There are no users, please create an account');
         readln
     end;
end;

Procedure CreateAccount;
Var
  userflag : boolean;
  passwords : text;

Begin

     userflag := false;    //whether the username is taken
     while userflag = false do
     begin
          userflag := true;
          clrscr;
          Writeln('Please enter your desired username');
          Write('>>> ');
          readln(tempuser);
          For count := 1 to usernums do
          begin
               if (tempuser = userinfo[count, 1]) OR (tempuser = 'admin') then  //if the username is taken
               begin
                    Writeln('Sorry, that username is taken, please choose another.');
                    userflag := false;
                    readln;
               end;
          end;
     end;
     clrscr;
     Writeln('Please enter your desired password.');
     Write('>>> ');
     readln(temppass);

     temppass := temppass + tempuser; //this is the salt for the hash generation
     temppass := MD5Print(MD5String(temppass));  //this generates the md5 hash
     assign(passwords, 'c:\Data\DVD_Database\passwords.txt');
     If (FileExists('c:\Data\DVD_Database\passwords.txt') = true) then
     begin
          append(passwords);
     end
     else
     begin
          rewrite(passwords);
     end;

     writeln(passwords, temppass);    //writes the password to file
     close(passwords);

     clrscr;
     Writeln('Please enter your full name.');
     Write('>>> ');
     readln(tempname);
     clrscr;
     Writeln('Please enter your address.');
     Write('>>> ');
     readln(tempaddress);
     clrscr;
     Writeln('Please enter your license number.');
     Write('>>> ');
     readln(templicense);
     clrscr;
     Writeln('Please enter your phone number.');
     Write('>>> ');
     readln(tempphone);
     clrscr;
     SetLength(UserInfo, (usernums + 2), 6);  //increases the length of the array
     SetLength(UserDVD, (usernums + 2));
     userinfo[(usernums + 1), 1] := tempuser;
     userinfo[(usernums + 1), 2] := tempname;
     userinfo[(usernums + 1), 3] := tempaddress;
     userinfo[(usernums + 1), 4] := tempphone;
     userinfo[(usernums + 1), 5] := templicense;
     UserDVD[(usernums + 1)] := 0;


     usernums := usernums + 1;      //increases the number of users

     Writeln('Account created, press any key to continue!');
     readln;
end;

Procedure ViewDVD;
Var

  i, j : integer;
  temp : string;
  DVDSort : boolean;
begin
     DVDSort := true;
     While DVDSort = true do
     begin
       clrscr;
       Writeln('Would you like to sort the DVDs by');
       Writeln('1. Name');
       Writeln('2. Genre');
       Writeln('3. Year');
       Writeln('Please select an option by typing 1, 2 or 3 and hitting enter.');
       Write('>>> ');
       readln(menuoption);
       Case menuoption of
            '1' : Begin
                searchterm := 1;
            end;
            '2' : Begin
                searchterm := 2;
            end;
            '3' : Begin
                searchterm := 3;
            end;
            else
              begin
                  clrscr;
                  Writeln('Please enter a number between 1 and 3');
                  readln;
              end;
       end;

       clrscr;

       For i := DVDNums-1 DownTo 1 do
       begin
           For j := 2 to i do
           If (DVDinfo[j-1, searchterm] > DVDinfo[j, searchterm]) then
           Begin
                temp := DVDinfo[j-1, searchterm];
                DVDinfo[j-1, searchterm] := DVDinfo[j, searchterm];
                DVDinfo[j, searchterm] := temp;
           end;
       end;

       For count := 1 to DVDNums do
       begin
            Writeln('Name: ', DVDinfo[count, 1]);
            Writeln('    Genre: ', DVDinfo[count, 2]);
            Writeln('     Year: ', DVDinfo[count, 3]);
            Writeln;
       end;

       Writeln('Would you like to');
       Writeln('1. Select a specific DVD');
       Writeln('2. Re-sort the DVDs');
       Writeln('3. Exit');
       Writeln('Please select an option by typing 1, 2 or 3 and hitting enter.');
       Write('>>> ');
       readln(menuoption);
       Case menuoption of
            '1' : Begin
                clrscr;
                writeln('Please enter the name of the DVD you wish to search for');
                write('>>> ');
                readln(inputdvd);
                dvdindex := DVDSearch(inputdvd);
                displayDVD;
            end;
            '2' : Begin
                DVDsort := true;
            end;
            '3' : Begin
                DVDsort := false;
            end;
            else
              begin
                  clrscr;
                  Writeln('Please enter a number between 1 and 3');
                  readln;
              end;
       end;
     end;
end;

begin
 loaddata;
 price := 11.5 //this can be changed, it is the weekly cost of a DVD
 exitflag := false;
 While exitflag = false do
 begin
  While loggedin = false do   //if not logged in, show this menu
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
                exitflag := true;
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


  While loggedin = true do     //when logged in, show this menu
  begin
       clrscr;
       Writeln('Welcome, ', currentuser, '!');
       Writeln('1. View DVDs');
       Writeln('2. Admin Menu');
       Writeln('3. Return DVD');
       Writeln('4. Logout');
       Writeln('Please select an option by typing 1, 2, 3 or 4 and hitting enter.');
       Write('>>> ');
       readln(menuoption);
       Case menuoption of
            '1' : Begin
                ViewDVD;
            end;
            '2' : Begin
                If currentuser = 'admin' then
                   adminmenu
                else
                begin
                    writeln('Sorry, but you are not logged in as an administrator');
                    readln;
                end;
            end;
            '3' : Begin
                If UserDVD[userid] = 0 then
                begin
                   clrscr;
                   writeln('Sorry, but you have not rented a DVD');
                   readln;
                end
                else
                begin
                    clrscr;
                    dvdindex := UserDVD[userid];
                    writeln('You are currently renting ', DVDInfo[dvdindex, 1], '.');
                    writeln('Do you wish to return it? Type "y" for yes, type "n" for no.');
                    write('>>> ');
                    readln(menuoption);
                    Case menuoption of
                    'y' : Begin
                        clrscr;
                        writeln('How many weeks have you had the DVD?');
                        readln(weeks);
                        total := weeks * price;
                        writeln('You have sucsessfully returned ', DVDInfo[dvdindex, 1], '.');
                        writeln('You owe $', total, '.');
                        UserDVD[userid] := 0;
                        dvdrented[dvdindex] := false;
                        readln;
                    end;
                end;
                end;
            end;
            '4' : Begin
                loggedin := false;
            end;
            else
              begin
                  clrscr;
                  Writeln('Please enter a number between 1 and 4');
                  readln;
              end;
       end;
  end;
 end;
end.





