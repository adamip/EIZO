using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.IO;
using System.IO.Ports;

namespace AdTechCommPort
{
    public class oCommPort
    {
        public SerialPort CommPort = null;
        /* use BinaryStream.ReadByte() to read byte 0..255  
         * StreamReader.Read(char[],0,1) reads in 0..65535 which is utf-8 but too large for this project */
        public BinaryReader binaryReader = null;
        public StreamWriter streamWriter = null;
        private Stream SerialPortStream = null;

        /* Constructor */
        public oCommPort(string s = null)
        {
            if (s != null)
            {
                CommPort = new SerialPort(s);
                if(isAvailable() == true)
                {
                    CommPort.Open();
                    SerialPortStream = CommPort.BaseStream;
                    binaryReader = new BinaryReader(SerialPortStream);
                    streamWriter = new StreamWriter(SerialPortStream);
                    streamWriter.Flush();
                    streamWriter.AutoFlush = true;
                }
            }
        }
        public virtual Boolean isAvailable()
        {
            return !(CommPort.IsOpen);
        }
        public virtual void Close()
        {
            if (isAvailable() == false)
            {   while(CommPort.BytesToWrite > 0)
                    streamWriter.Flush();                
                CommPort.Dispose();
            }
            return;

        }
    }
}
