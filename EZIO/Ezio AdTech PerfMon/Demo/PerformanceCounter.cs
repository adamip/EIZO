// main form's private variables
private PerformanceCounter cpuCounter = null;
private PerformanceCounter ramCounter = null;
private PerformanceCounter pageCounter = null;
private PerformanceCounter[] nicCounters = null;

// called in Form.Load
private void InitCounters()
{
    try
    {
        cpuCounter = new PerformanceCounter
            ("Processor", "% Processor Time", "_Total", machineName);
        ramCounter = new PerformanceCounter
            ("Memory", "Available MBytes", String.Empty, machineName);
        pageCounter = new PerformanceCounter
            ("Paging File", "% Usage", "_Total", machineName);
    }
    catch (Exception ex)
    {
        SysCounters.Program.HandleException
            (String.Format("Unable to access computer 
            '{0}'\r\nPlease check spelling and verify 
            this computer is connected to the network", 
            this.machineName));
        Close();
    }
}

// called by Timer
private void tTimer_Tick(object sender, EventArgs e)
{
    try
    {
        tsCPU.Text = String.Format("{0:##0} %", cpuCounter.NextValue());
        tsRAM.Text = String.Format("{0} MB", ramCounter.NextValue());
        tsPage.Text = String.Format("{0:##0} %", pageCounter.NextValue());

        for (int i = 0; i  < nicCounters.Length; i++)
        {
            ssStatusBar.Items[String.Format("tsNIC{0}", i)].Text = 
                String.Format("{0:####0 KB}", 
                nicCounters[i].NextValue() / 1024);
        }
    }
    catch (Exception ex)
    {
        // remote computer might have become unavailable; 
        // show exception and close this application
        tTimer.Enabled = false;
        SysCounters.Program.HandleException(ref ex);
        Close();
    }
}
        
// called in Form.Closing
private void DisposeCounters()
{
    try
    {
        // dispose of the counters
        if (cpuCounter != null)
        { cpuCounter.Dispose(); }
        if (ramCounter != null)
        { ramCounter.Dispose(); }
        if (pageCounter != null)
        { pageCounter.Dispose(); }
        if (nicCounters != null)
        {
            foreach (PerformanceCounter counter in nicCounters)
            { counter.Dispose(); }
        }
    }
    finally
    { PerformanceCounter.CloseSharedResources(); }
} 