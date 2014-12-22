using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.IO.Ports;

namespace AdTechCommPort
{
    public class EzioCommPort : oCommPort
    {
        public enum CmdList : int { Blank = 1, ClearScreen, Hide, HomeCursor, Initialize, MoveLeft, MoveRight,
        ReadKey, ScrollLeft, ScrollRight, SetCurPos, SetDisplay, ShowUnderline, StopSend, TurnOn
        };

        /* Constructor */
        public EzioCommPort(string s = null) : base(s){ }

        /* initializing after the contractor */
        public void Initialize() 
        {
            base.CommPort.BaudRate = 2400;
            base.CommPort.Parity = Parity.None;
            base.CommPort.DataBits = 8;
            base.CommPort.StopBits = StopBits.One;
            Command(CmdList.Initialize);
            Command(CmdList.Initialize);
            Command(CmdList.ClearScreen);
        }

        public int Command(CmdList command)
        {   
            int ret = 0;
            char[] Cmd = new char [1] {(char) 254}; 
            char[] toSend = new char[1] {(char) 0};
            switch (command)
            {
                case CmdList.Blank:         toSend[0] = (char)8;    break;  /* blank display; retains data */
                case CmdList.ClearScreen:   toSend[0] = (char)1;    break;
                case CmdList.Hide:          toSend[0] = (char)12;   break;  /* hide cursor and display blanked characters */
                case CmdList.HomeCursor:    toSend[0] = (char)2;    break;  
                case CmdList.Initialize:    toSend[0] = (char)40;   break;  /* Start of HEX */  
                case CmdList.MoveLeft:      toSend[0] = (char)16;   break;  /* move cursor 1 character left */
                case CmdList.MoveRight:     toSend[0] = (char)20;   break;  /* move cursor 1 character right */
                case CmdList.ReadKey:       toSend[0] = (char)6;    break;
                case CmdList.ScrollLeft:    toSend[0] = (char)24;   break;  /* scroll cursor 1 character left */
                case CmdList.ScrollRight:   toSend[0] = (char)28;   break;  /* scroll cursor 1 character right */
                case CmdList.SetCurPos:     toSend[0] = (char)128;  break;  /* set cursor position; set display address */
                case CmdList.SetDisplay:    toSend[0] = (char)64;   break;  /* set display; set character-generator address */
                case CmdList.ShowUnderline: toSend[0] = (char)14;   break;  /* show underline cursor */
                case CmdList.StopSend:      toSend[0] = (char)55;   break;  /* End of HEX */
                case CmdList.TurnOn:        toSend[0] = (char)13;   break;  /* turn on; blinking block cursor */
                default:    ret = -1;   break;
            }
            if (toSend[0] != 0)
            {
                Write(Cmd);
                Write(toSend);
                if (command == CmdList.ReadKey)
                    ret = ReadByte(); 
            }
            return ret;
        }
    }
}
