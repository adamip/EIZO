using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace AdTechCommPort
{
    class Program
    {
        static bool bContinue = true;
        static oLog myLog = null;
        static EzioCommPort myCommPort = null;

        static void Main(string[] args)
        {
            string sCompany = "Adtech";
            myLog = new oLog();
            int iEscPressed = 0;

            myCommPort = new EzioCommPort("COM2");
            myCommPort.Initialize();
            myLog.WriteLine( "COM2 initialized." );

            myCommPort.Write(sCompany);

            while (bContinue)
            {
                if (iEscPressed == 3)
                    bContinue = false;
                else
                {
                    int c = myCommPort.CommPort.ReadChar();

                    
                }
            }
            

            myCommPort.Close();
            return;
        }
    }
}
