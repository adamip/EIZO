using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace AdTechCommPort
{
    class Program
    {
        static void Main(string[] args)
        {
            oLog myLog = new oLog(); 
            string sCompany = "Adtech Global", sNow;
            
            bool bContinue = true;
            int MAX_ESC = 4;

            EzioCommPort myCommPort = new EzioCommPort("COM2");
            myCommPort.Initialize();
            myLog.WriteLine( "COM2 initialized." );

            /* show company name and current time */
            sNow = String.Format("{0:g}", DateTime.Now);
            if (sNow.Length > 16)
                sNow = sNow.Substring(0, sNow.Length - 3);
            myCommPort.WriteFirstLine(sCompany); 
            myCommPort.WriteSecondLine(sNow);

            /* to demo key press, after press 'Entr' */
            while( myCommPort.Command(CmdList.ReadKey) != 'r' )
                ;
            /* prepare the screen */
            myCommPort.Command(CmdList.ClearScreen);
            myCommPort.WriteFirstLine("Adtech");

            for(int iEscPressed = 0, iloop = 0; bContinue == true; )
            {
                if (iEscPressed >= MAX_ESC)
                    bContinue = false;
                else
                {
                    char c = myCommPort.Command(CmdList.ReadKey);
                    switch (c)
                    {
                        case 'U':
                        case 'u':
                            myCommPort.WriteSecondLine("Up              ");
                            iEscPressed = 0;
                            break;
                        case 'D':
                        case 'd':
                            myCommPort.WriteSecondLine("Down            ");
                            iEscPressed = 0;
                            break;
                        case 'R':
                        case 'r':
                            myCommPort.WriteSecondLine("Enter           ");
                            iEscPressed = 0;
                            break;
                        case 'E':
                        case 'e':
                            //myCommPort.WriteSecondLine("Esc");
                            ++iEscPressed;
                            string CountEsc = "Esc  " + ( iEscPressed ).ToString();
                            myCommPort.WriteSecondLine( CountEsc );
                            break;
                        default:
                            break;
                    }
                    myCommPort.WritePos(++iloop, 7);
                }
            }
            myCommPort.Close();
            return;
        }
    }
}
