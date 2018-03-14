Set-ExecutionPolicy -Scope Process Unrestricted -Force
. .\compress-VirotGoogleEncodedPolyline.ps1

Describe "Test compression" {
  Context "Long/Lat" {
    It "Step by Step" {
      compress-VirotGoogleEncodedPolyline -coordinates @('-179.9832104,0') | Should Be '`~oia@?'
    }
    It "Examples" {
      compress-VirotGoogleEncodedPolyline -coordinates @('38.5,-120.2','40.7,-120.95','43.252,-126.453') | Should Be '_p~iF~ps|U_ulLnnqC_mqNvxq`@'
    }
    It "Stockholm-Old Town" {
      compress-VirotGoogleEncodedPolyline -coordinates @('59.32765,18.06273','59.32776,18.06578','59.32855,18.06775','59.32903,18.07110','59.32741,18.07599','59.32406,18.07870','59.32107,18.07531','59.32194,18.06389','59.32584,18.05900') | Should Be 'ylbiJa{fmBUaR}CiK_B}SbIq]|S}OtQdTmDjfAkWp]'
    }
  }
}


