using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.IO.Ports;

namespace AdTechCommPort
{
    public enum CmdList : int
    {
        Blank = 1, ClearScreen, Hide, HomeCursor, Initialize, MoveLeft, MoveRight,
        ReadKey, ScrollLeft, ScrollRight, SetCurPos, SetDisplay, ShowUnderline, StopSend, TurnOn
    };

    /* Up = 0x4D, Down = 0x47, Enter = 0x4B, Esc = 0x4E */
    public enum LCDKey : int { Up = 0x4D, Down = 0x47, Enter = 0x4B, Esc = 0x4E };

    public class EzioCommPort : oCommPort
    {
        /* Constructor */
        public EzioCommPort(string s = null) : base(s){ }

        /* initializing after the contractor */
        public void Initialize() 
        {
            if (base.CommPort != null && isAvailable() == false )
            {
                base.CommPort.BaudRate = 2400;
                base.CommPort.Parity = Parity.None;
                base.CommPort.DataBits = 8;
                base.CommPort.StopBits = StopBits.One;
                base.CommPort.Handshake = Handshake.None;
                base.CommPort.ReadTimeout = SerialPort.InfiniteTimeout;    
                base.CommPort.WriteTimeout = 500;   /* millisecond */
                Command(CmdList.Initialize);
                Command(CmdList.Initialize);
                Command(CmdList.ClearScreen);
            }
        }

        public char Command(CmdList command, int pos = 0)
        {
            char ret = (char) 0;
            byte key = 0, header, hi_status, lo_status;
            byte[] Cmd = new byte[1] { 254 }; 
            byte[] toSend = new byte[1] { 0 };
            switch (command)
            {
                case CmdList.Blank:         toSend[0] = 8;    break;  /* blank display; retains data */
                case CmdList.ClearScreen:   toSend[0] = 1;    break;
                case CmdList.Hide:          toSend[0] = 12;   break;  /* hide cursor and display blanked characters */
                case CmdList.HomeCursor:    toSend[0] = 2;    break;  
                case CmdList.Initialize:    toSend[0] = 40;   break;  /* Start of HEX */  
                case CmdList.MoveLeft:      toSend[0] = 16;   break;  /* move cursor 1 character left */
                case CmdList.MoveRight:     toSend[0] = 20;   break;  /* move cursor 1 character right */
                case CmdList.ReadKey:       toSend[0] = 6;    break;
                case CmdList.ScrollLeft:    toSend[0] = 24;   break;  /* scroll cursor 1 character left */
                case CmdList.ScrollRight:   toSend[0] = 28;   break;  /* scroll cursor 1 character right */
                case CmdList.SetCurPos: toSend[0] = (byte)(128 + pos); break;  /* set cursor position; set display address */
                case CmdList.SetDisplay:    toSend[0] = 64;   break;  /* set display; set character-generator address */
                case CmdList.ShowUnderline: toSend[0] = 14;   break;  /* show underline cursor */
                case CmdList.StopSend:      toSend[0] = 55;   break;  /* End of HEX */
                case CmdList.TurnOn:        toSend[0] = 13;   break;  /* turn on; blinking block cursor */
                default:    break;
            }
            if (toSend[0] != 0)
            {
                base.CommPort.Write(Cmd, 0, 1);
                base.CommPort.Write(toSend, 0, 1);
                if (command == CmdList.ReadKey)
                {
                    header = base.binaryReader.ReadByte();
                    if (header == 253)
                    {
                        key = base.binaryReader.ReadByte();
                        hi_status = (byte)( key & 240 );
                        lo_status = (byte)( key & 15 );
                        switch( lo_status )
                        {
                            case 7:     ret = 'e'; break;
                            case 14:    ret = 'u'; break;
                            case 11:    ret = 'r'; break;
                            case 13:    ret = 'd'; break;
                        }
                    }
                }
            }
            return ret;
        }
        public void WritePos(object s, int pos)
        {
            Command(CmdList.SetCurPos, pos);
            base.streamWriter.Write(s);
        }
        public void WriteFirstLine(object s)
        {
            Command(CmdList.SetCurPos, 0);
            base.streamWriter.Write(s);
        }
        public void WriteSecondLine(object s)
        {
            Command(CmdList.SetCurPos, 40);
            base.streamWriter.Write(s);
        }
    }
}
