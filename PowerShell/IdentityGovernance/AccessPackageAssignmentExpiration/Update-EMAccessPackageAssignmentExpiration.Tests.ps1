. .\Update-EMAccessPackageAssignmentExpiration.ps1

Describe InScopeDate {
    It 'Should return Correct Expiration endDateTime' {
        $ExpirationDate = ((get-date -AsUTC).ToUniversalTime()).AddDays(20)
        $updated = Update-EMAccessPackageAssignmentExpiration -AccessPackageAssignmentId af31c660-5503-4b6e-a2c3-f6d2a7ed145f -ExpirationDateTime $ExpirationDate
        $updated.requestStatus | Should -be "Accepted"
        ((Get-Date $updated.schedule.expiration.endDateTime -AsUTC).ToUniversalTime()) | Should -be $ExpirationDate
    }


    It 'Attempting to set assignment to not expire should throw exception' {
        $ExceptionMessage = "RuntimeException: Updating an expiring assignment to no expiration is not currently supported!"
        Update-EMAccessPackageAssignmentExpiration -AccessPackageAssignmentId af31c660-5503-4b6e-a2c3-f6d2a7ed145f -SetNoExpiration | should -Throw -ExpectedMessage $ExceptionMessage

    }

    It 'Attempting to set assignment to timespan outside of the assignment policy timespan should throw exception' {
        $ExpirationDate = ((get-date -AsUTC).ToUniversalTime()).AddDays(1000)
        Update-EMAccessPackageAssignmentExpiration -AccessPackageAssignmentId af31c660-5503-4b6e-a2c3-f6d2a7ed145f -ExpirationDateTime $ExpirationDate | should -Throw

    }

}