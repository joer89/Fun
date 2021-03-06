﻿<#
.Synopsis
    Logs your body statistics to the BodyStatistics database on the SQL Server.
.Description
    This script has a menu option for reading and writing to a SQL Database.
    You will need to edit the following;
        Connection string.
        Table name.
        SQL Queries to connect to the database.
    It logs the following;
        Weight.
        Fat Percentage.
        Hight.
        Shoulder circumference.
        Chest circumference.
        Arm circumference.
        Waist circumference.
        Upper leg circumference.
        Lower Leg circumference.
        Logs the date and time.
.Notes
        Author: Joe Richards
        Date:   11-02-2017
.LINK
  https://github.com/joer89/Fun/BodyStatistics_Logs/
#>


#Displays all query in order by date and time ascending
$SQLSelectAll =  "SELECT * FROM tblJoeRichards ORDER BY Date_Time ASC"
#Inserts new line query.
$SQLInsertNewLine = "Insert INTO tblJoeRichards (MyWeight,FatPercentage,Hight,Shoulder,Chest,Arms,Waist,Upper_leg,Lower_Leg,Date_Time) values ('$MyWeight','$FatPercentage','$Hight','$Shoulder','$Chest','$Arms','$Waist','$Upper_leg','$Lower_Leg','$Date_Time')"
#Connection string to the BodyStatistics database.
$ConnString = "SERVER=localhost; database=BodyStatistics; USER Id=sa; Password=sa;"
#Gives the strings a purpose.
$conn = New-Object System.Data.SqlClient.SqlConnection
$cmd = New-Object System.Data.SqlClient.SqlCommand
#Delaires the connection.
$cmd.Connection = $conn
#uses the connection string for connecting to the SQL DB BodyStatistics.
$conn.ConnectionString = $ConnString
#Logs the current connection state.
[switch]$connected = $false

#Creates the connection to SQL.
function SQLConnect{
    try{
        #Opens the connection to the database.
        $conn.Open()
        #Writes on the screen.
        Write-host "`n `t Connected."  -ForegroundColor Magenta
        $script:connected = $true
    }
    catch{        
        #Writes on the screen.
        Write-Host "Failed to connect to the database BodyStatistics."  -ForegroundColor Red
         $script:connected = $false
    }
}#end function

#Close the SQL Connection.
function SQLConnClose{
    try{
        #Close the SQL Connection.
        $conn.Close()  
        Write-host "`n `t Disconnected." -ForegroundColor Magenta
        $script:connected = $false             
    }
    catch{
        Write-Host "Failed to close the connection to the BodyStatistics database."   -ForegroundColor Red  
    }
}#End function

#Reads from the SQL Database.
function SQLReader{
    #Clears the screen.
    cls
    #Opens the connection.
    SQLConnect
    #Checks to see if the connection is open.
    if($connected){
            Write-Host "`t Reading data" -ForegroundColor Magenta
            #Queries everything from the database.
            $cmd.CommandText = $SQLSelectAll
            #Reads the Data from the database.
            $result = $cmd.ExecuteReader()
            #Reads the results from the SQL Database.
            while($result.Read()){  
                #Writes the SQL data on the screen.     
                Write-Host "`t Weight: $($result.GetValue(0))"
                Write-Host "`t Fat Percentage: $($result.GetValue(1))"
                Write-Host "`t Hight: $($result.GetValue(2))"
                Write-Host "`t Shoulders: $($result.GetValue(3))" 
                Write-Host "`t Chest: $($result.GetValue(4))"
                Write-Host "`t Arms: $($result.GetValue(5))" 
                Write-Host "`t Waist: $($result.GetValue(6))"  
                Write-Host "`t Upper leg: $($result.GetValue(7))"
                Write-Host "`t Lower leg: $($result.GetValue(8))"
                Write-Host "`t Date: $($result.GetValue(9))"
                Write-Host "`n"
            }
        Write-host "`t Finished reading data." -ForegroundColor Magenta
        #Close the reader.
        $result.Close()
        #Close the connection
        SQLConnClose
        }
    #Displays the main menu.
    Menu
}#End function

#Terrogate the user for details.
function QueryUser{
    #Displays out to the screen.
    Write-host "Please enter your details below.`n"  -ForegroundColor Magenta
    #Questions for the user that gets put in the SQL intert query string.
    $Script:MyWeight =  Read-Host "`n Weight"
    $Script:FatPercentage  =  Read-Host "`n Fat Percentage "
    $Script:Hight = Read-Host "`n Hight"
    $Script:Shoulder = Read-host "`n Shoulder circumference "
    $Script:Chest = Read-host "`n Chest circumference "
    $Script:Arms = Read-host "`n Arm circumference "
    $Script:Waist = Read-host "`n Waist circumference "
    $Script:Upper_leg = Read-host "`n Upper leg circumference "
    $Script:Lower_Leg = Read-host "`n Lower Leg circumference "
    $Script:Date_Time = get-date | Out-String 
    #Inserts the data to the database.
    SQLInsertBodyStat    
}#End function

#Inserts a new line to the SQL Database.
function SQLInsertBodyStat{   
    #Opens the connection.
    SQLConnect
    #Checks to see if the connection is open.
    if($connected){
        Write-Host "`t Inserting new data"  -ForegroundColor Magenta
        #Queries everything from the database.
        $cmd.CommandText = $SQLInsertNewLine 
        $cmd.ExecuteNonQuery()
        Write-Host "`t Finished inserting data"  -ForegroundColor Magenta
        #Close the connection
        SQLConnClose
    }#end if   
    #Displays the main menu.
    Menu
}#End function

#Displays the menu.
function Menu{
    #Writes on the screen.
    Write-Host "`nWelcome to the Body Statistics log`n"  -ForegroundColor Yellow #Magenta
    Write-Host "1.   Display your statistics."
    Write-Host "2.   Add new statistics."
    Write-Host "3.   Close the program."
    #User input
    Write-Host "`nPlease make a numeric choice. " -ForegroundColor Red -NoNewline
    #Stores the users numeric choice.
    $Input = Read-Host 
    #Runs the function specified by the user.
        switch($Input){
            '1'{SQLReader}
            '2'{QueryUser}
            '3'{Exit}
        }#End switch
}#End function.

#Clears the screen
cls
#Displays the main menu.
Menu
