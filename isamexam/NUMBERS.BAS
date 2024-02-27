OPTION EXPLICIT
DEFINT A-Z

TYPE NumberStr
 Number AS STRING * 10
END TYPE

DECLARE SUB CreateDataBase (Numbers() AS NumberStr)
DECLARE SUB DeleteNumberTable ()
DECLARE SUB DisplayDatabase ()
DECLARE SUB ReadNumberList (Numbers() AS NumberStr)

DIM Numbers() AS NumberStr

CLS

DeleteNumberTable
ReadNumberList Numbers()
CreateDataBase Numbers()
DisplayDatabase
END

NumberList:
DATA "zero"
DATA "one"
DATA "two"
DATA "three"
DATA "four"
DATA "five"
DATA "six"
DATA "seven"
DATA "eight"
DATA "nine"
DATA "ten"
DATA "*"

SUB CreateDataBase (Numbers() AS NumberStr)
DIM FileH AS INTEGER
DIM Index AS INTEGER

 FileH = FREEFILE
 OPEN "Numbers.mdb" FOR ISAM NumberStr "NumberTable" AS FileH
  FOR Index = LBOUND(Numbers) TO UBOUND(Numbers)
   INSERT #FileH, Numbers(Index)
  NEXT Index
 CLOSE FileH
END SUB

SUB DeleteNumberTable ()
ON LOCAL ERROR RESUME NEXT
 IF NOT DIR$("Numbers.mdb") = "" THEN
  DELETETABLE "Numbers.mdb", "NumberTable"
 END IF
END SUB

SUB DisplayDatabase ()
DIM FileH AS INTEGER
DIM Index AS INTEGER
DIM NumbersInDatabase(0 TO 0) AS NumberStr

 FileH = FREEFILE
 OPEN "Numbers.mdb" FOR ISAM NumberStr "NumberTable" AS FileH
  DO
   RETRIEVE #FileH, NumbersInDatabase(UBOUND(NumbersInDatabase))
   MOVENEXT FileH
   IF EOF(FileH) THEN
    EXIT DO
   END IF
   REDIM PRESERVE NumbersInDatabase(LBOUND(NumbersInDatabase) TO UBOUND(NumbersInDatabase) + 1) AS NumberStr
  LOOP
 CLOSE FileH

 FOR Index = LBOUND(NumbersInDatabase) TO UBOUND(NumbersInDatabase)
  PRINT NumbersInDatabase(Index).Number
 NEXT Index
END SUB

SUB ReadNumberList (Numbers() AS NumberStr)
 RESTORE NumberList

 REDIM Numbers(0 TO 0) AS NumberStr
 DO
  READ Numbers(UBOUND(Numbers)).Number

  IF RTRIM$(Numbers(UBOUND(Numbers)).Number) = "*" THEN
   REDIM PRESERVE Numbers(LBOUND(Numbers) TO UBOUND(Numbers) - 1) AS NumberStr
   EXIT DO
  END IF

  REDIM PRESERVE Numbers(LBOUND(Numbers) TO UBOUND(Numbers) + 1) AS NumberStr
 LOOP
END SUB

