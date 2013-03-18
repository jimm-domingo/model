; This file reads the software's release status from a text file (see below for
; the file's path).  The release status is on the file's first line in one of
; these formats:
;
;    alpha release (#)
;    beta release (#)
;    release candidate (#)
;    official release
;    official release, revision (#)
;
; where (#) is an integer = or > 1.  Example: "beta release 3".
; This file defines these variables:
;
;    Release = (the release status read from the file)
;    ReleaseType = alpha, beta, candidate, official, revision
;    ReleaseNumber = (#)  (defined if ReleaseType = alpha, beta or candidate)
;    RevisionNumber = (#) (defined if ReleaseType = revision)
;    ReleaseAbbr = a#, b#, rc#, "" (empty string for official), rev#

#define ReleaseStatusFile "..\release-status.txt"
#pragma message 'Reading release status from "' + ReleaseStatusFile + '"'

#if ! FileExists(ReleaseStatusFile)
  #pragma error 'The file "' + ReleaseStatusFile + '" does not exist'
#endif
#define FileHandle FileOpen(ReleaseStatusFile)
#if FileHandle == 0
  #pragma error 'Cannot open the file "' + ReleaseStatusFile + '"'
#endif
#define Release FileRead(FileHandle)
#expr FileClose(FileHandle)
#if Release == ""
  #pragma error 'Cannot read release information from the file "' + ReleaseStatusFile + '"'
#endif

#pragma message 'Release status = "' + Release + '"'

#define Release Trim(Release)

#if Release == "official release"
  #define ReleaseType "official"
  #define ReleaseAbbr ""
#else
  ; Numbered release
  #if Copy(Release, 1, 13) == "alpha release"
    #define ReleaseType "alpha"
    #define ReleaseTypeAbbr "a"
    #define PosOfReleaseNumber 14
  #elif Copy(Release, 1, 12) == "beta release"
    #define ReleaseType "beta"
    #define ReleaseTypeAbbr "b"
    #define PosOfReleaseNumber 13
  #elif Copy(Release, 1, 17) == "release candidate"
    #define ReleaseType "candidate"
    #define ReleaseTypeAbbr "rc"
    #define PosOfReleaseNumber 18
  #elif Copy(Release, 1, 26) == "official release, revision"
    #define ReleaseType "revision"
    #define ReleaseTypeAbbr "rev"
    #define PosOfReleaseNumber 27
  #else
    #pragma error 'Invalid release status: "' + Release + '"'
  #endif
  #define ReleaseNumber Trim(Copy(Release, PosOfReleaseNumber))
  #if ReleaseNumber == ""
    #pragma error 'No number in release status: "' + Release + '"'
  #endif
  #define ReleaseAbbr ReleaseTypeAbbr + ReleaseNumber

#endif

#pragma message 'Release type = "' + ReleaseType + '"'
#ifdef ReleaseNumber
  #pragma message 'Release number = "' + ReleaseNumber + '"'
  #define ReleaseNumber Int(ReleaseNumber)
  #if ReleaseNumber < 1
    #error The number in release status is 0 or negative
  #endif
  #if ReleaseType == "revision"
    #define RevisionNumber ReleaseNumber
    #undef  ReleaseNumber
  #endif
#endif
#pragma message 'Release abbreviation = "' + ReleaseAbbr + '"'

