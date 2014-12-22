using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace AdTechCommPort
{
    public class oLog
    {
        internal StreamWriter sw;
        // Constructor
        public oLog()
        {
            /* Reference http://msdn.microsoft.com/en-us/library/system.console.out.aspx */
            // Close previous output stream and redirect output to standard output.
            Console.Out.Close();
            sw = new StreamWriter(Console.OpenStandardOutput());
            sw.AutoFlush = true;
            Console.SetOut(sw);
        }
        // Destructor
        ~oLog() { }
        public void Write(object o)
        {
            sw.Write(o);
        }        
        public void WriteLine(object o)
        {
            sw.WriteLine(o);
        }
    }
}
