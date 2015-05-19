using System;

namespace AzureTest.Service
{
    public class TimeService
    {
        /// <summary>
        /// This is a dummy service just for testing a multi-project solution.
        /// </summary>
        /// <returns>Current date and time</returns>
        public DateTime GetCurrentDateTime()
        {
            return DateTime.Now;
        }
    }
}
