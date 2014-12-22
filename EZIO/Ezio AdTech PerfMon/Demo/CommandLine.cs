// specify remote computer to monitor via command line param
private void GetMachineName()
{
    string[] cmdArgs = System.Environment.GetCommandLineArgs();
    if ((cmdArgs != null) && (cmdArgs.Length > 1))
    { this.machineName = cmdArgs[1]; }
}

// ping the remote computer 
private bool VerifyRemoteMachineStatus(string machineName)
{
    try
    {
        using (Ping ping = new Ping())
        {
            PingReply reply = ping.Send(machineName);
            if (reply.Status == IPStatus.Success)
            { return true; }
        }
    }
    catch (Exception ex)
    { 
        // return false for any exception encountered
        // we'll probably want to just shut down anyway
    }
    return false;
} 