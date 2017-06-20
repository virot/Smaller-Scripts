Set-ExecutionPolicy -Scope Process Unrestricted -Force
. .\Convert-Int2Complement.ps1

Describe "Negative to positive" {
  Context "16 bit integers" {
    It "Verify output type" {
      (Convert-Int2Complement -Integer ([int16]-1)).gettype().Name | Should Be 'UInt16'
    }
    It "Verify Max" {
      Convert-Int2Complement -Integer ([int16]-1) | Should Be ([uint16]::MaxValue)
    }
    It "First break" {
      (Convert-Int2Complement -Integer ([int16]::MinValue)) | Should Be ([int16]::MaxValue+1)
    }
    It "Zero" {
      Convert-Int2Complement -Integer ([int16]0) | Should Be '0'
    }
    It "Non converted" {
      Convert-Int2Complement -Integer ([int16]1) | Should Be '1'
    }
  }
  Context "32 bit integers" {
    It "Verify output type" {
      (Convert-Int2Complement -Integer ([int32]-1)).gettype().Name | Should Be 'UInt32'
    }
    It "Verify Max" {
      (Convert-Int2Complement -Integer ([int32]-1)) | Should Be ([uint32]::MaxValue)
    }
    It "First break" {
      (Convert-Int2Complement -Integer ([int32]::MinValue)) | Should Be ([int32]::MaxValue+1)
    }
    It "Zero" {
      (Convert-Int2Complement -Integer ([int32]0)) | Should Be '0'
    }
    It "Non converted" {
      (Convert-Int2Complement -Integer ([int32]1)) | Should Be '1'
    }
  }
  Context "64 bit integers" {
    It "Verify output type" {
      (Convert-Int2Complement -Integer ([int64]-1)).gettype().Name | Should Be 'UInt64'
    }
    It "Verify Max" {
      (Convert-Int2Complement -Integer ([int64]-1)) | Should Be ([uint64]::MaxValue)
    }
    It "First break" {
      (Convert-Int2Complement -Integer ([int64]::MinValue)) | Should Be ([int64]::MaxValue+1)
    }
    It "Zero" {
      (Convert-Int2Complement -Integer ([int64]0)) | Should Be '0'
    }
    It "Non converted" {
      (Convert-Int2Complement -Integer ([int64]1)) | Should Be '1'
    }
  }
}

Describe "Positive to negative" {
  Context "16 bit integers" {
    It "Verify output type" {
      (Convert-Int2Complement -Integer ([uint16]0)).gettype().Name | Should Be 'int16'
    }
    It "Verify Max" {
      Convert-Int2Complement -Integer ([uint16]::MaxValue) | Should Be ([int16]-1)
    }
    It "First break" {
      (Convert-Int2Complement -Integer ([uint16]([uint16]::MaxValue/2))) | Should Be ([int16]::MinValue)
      (Convert-Int2Complement -Integer ([uint16]([uint16]::MaxValue/2))).gettype().Name | Should Be 'int16'
    }
    It "Zero" {
      Convert-Int2Complement -Integer ([uint16]0) | Should Be '0'
    }
    It "Non converted" {
      Convert-Int2Complement -Integer ([uint16]1) | Should Be '1'
    }
  }
  Context "32 bit integers" {
    It "Verify output type" {
      (Convert-Int2Complement -Integer ([uint32]0)).gettype().Name | Should Be 'int32'
    }
    It "Verify Max" {
      Convert-Int2Complement -Integer ([uint32]::MaxValue) | Should Be ([int32]-1)
    }
    It "First break" {
      (Convert-Int2Complement -Integer ([uint32]([uint32]::MaxValue/2))) | Should Be ([int32]::MinValue)
      (Convert-Int2Complement -Integer ([uint32]([uint32]::MaxValue/2))).gettype().Name | Should Be 'int32'
    }
    It "Zero" {
      (Convert-Int2Complement -Integer ([uint32]0)) | Should Be '0'
    }
    It "Non converted" {
      (Convert-Int2Complement -Integer ([uint32]1)) | Should Be '1'
    }
  }
  Context "64 bit integers" {
    It "Verify output type" {
      (Convert-Int2Complement -Integer ([uint64]0)).gettype().Name | Should Be 'int64'
    }
    It "Verify Max" {
      Convert-Int2Complement -Integer ([uint64]::MaxValue) | Should Be ([int64]-1)
    }
    It "First break" {
      (Convert-Int2Complement -Integer ([uint64]([uint64]::MaxValue/2))) | Should Be ([int64]::MinValue)
    }
    It "Zero" {
      (Convert-Int2Complement -Integer ([uint64]0)) | Should Be '0'
    }
    It "Non converted" {
      (Convert-Int2Complement -Integer ([uint64]1)) | Should Be '1'
    }
  }
}