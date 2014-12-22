// Load and save last window position
// simple way to do it so that we can run multiple instances 
// (one per machine) and still have them all save their position
private void LoadSettings()
{
    int iLeft = 0;
    int iTop = 0;

    System.Configuration.Configuration config = 
        ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
    try
    {
        // TryParse will default to zero on an invalid value
        int.TryParse(ConfigurationManager.AppSettings[String.Format
            ("{0}-Left", this.machineName)], out iLeft);
        int.TryParse(ConfigurationManager.AppSettings[String.Format
            ("{0}-Top", this.machineName)], out iTop);
    }
    finally
    {
        this.Left = iLeft;
        this.Top = iTop;
        config = null;
    }
}

private void SaveSettings()
{
    System.Configuration.Configuration config = 
        ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
    try
    {
        // remove the previously saved values
        config.AppSettings.Settings.Remove
            ring.Format("{0}-Left", this.machineName));
        config.AppSettings.Settings.Remove
            ring.Format("{0}-Top", this.machineName));
        // save our current values
        // this saves to app.config so it may be a permissions issue 
        //or non-admin users
        config.AppSettings.Settings.Add(String.Format("{0}-Left", 
            this.machineName), this.Left.ToString());
        config.AppSettings.Settings.Add(String.Format("{0}-Top", 
            this.machineName), this.Top.ToString());
        config.Save(ConfigurationSaveMode.Modified);
    }
    finally
    { config = null; }
} 