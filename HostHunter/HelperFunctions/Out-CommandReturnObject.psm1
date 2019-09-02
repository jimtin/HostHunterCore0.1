function Out-CommandReturnObject
{
    <# 
    .Synopsis
     Takes the return from Invoke-Command, adds in unique CommandID hash, then sends to SIEM
     
     .Description
     Takes the return from Invoke-Command, adds in unique CommandID hash, then sends to SIEM
     
     .Parameter
     CommandID - the unique CommandID hash to be attached to object
     
     .Parameter
     InvokeObject - the object returned by InvokeCommand 
     
     .Example
     Out-AccountabilityObject -CommandID $CommandID -InvokeObject $Output
    
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]$CommandID,
        [Parameter(Mandatory=$true)]$InvokeObject
    )

    # Take the $Output field and iterate through
    
    foreach($object in $InvokeObject)
    {
        # Add unique identifier
        $object | Add-Member -NotePropertyName "CommandID" -NotePropertyValue $CommandID
        
        # Convert to JSON string
        $fullobject = $object | ConvertTo-Json | Out-String
        
        # Send to SIEM
        Out-SIEM -StringToSend $fullobject
        
        # Wait for 15 milliseconds to clear buffer
        Start-Sleep -Milliseconds 15
    }

}
