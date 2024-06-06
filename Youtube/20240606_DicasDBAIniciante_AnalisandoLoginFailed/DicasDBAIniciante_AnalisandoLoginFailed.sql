DECLARE @ErrorLogCount INT;
DECLARE @LastLogDate DATETIME;

DECLARE @ErrorLogInfo TABLE
(
    LogDate DATETIME,
    ProcessInfo NVARCHAR(50),
    [Text] NVARCHAR(MAX)
);

DECLARE @EnumErrorLogs TABLE
(
    [Archive#] INT,
    [Date] DATETIME,
    LogFileSizeMB INT
);

INSERT INTO @EnumErrorLogs
EXEC sp_enumerrorlogs;

SELECT @ErrorLogCount = MIN([Archive#]),
       @LastLogDate = MAX([Date])
FROM @EnumErrorLogs;

WHILE @ErrorLogCount IS NOT NULL
BEGIN

    INSERT INTO @ErrorLogInfo
    EXEC sp_readerrorlog @ErrorLogCount;

    SELECT @ErrorLogCount = MIN([Archive#]),
           @LastLogDate = MAX([Date])
    FROM @EnumErrorLogs
    WHERE [Archive#] > @ErrorLogCount
          AND @LastLogDate > GETDATE() - 7;

END;

-- List all last week failed logins count of attempts and the Login failure message
SELECT COUNT(Text) AS NumberOfAttempts,
       Text AS Details,
       MIN(LogDate) AS MinLogDate,
       MAX(LogDate) AS MaxLogDate
FROM @ErrorLogInfo
WHERE ProcessInfo = 'Logon'
      AND Text LIKE '%fail%'
--AND LogDate > getdate() - 7
GROUP BY Text
ORDER BY NumberOfAttempts DESC;