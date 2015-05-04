using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using ZXing;
using ZXing.QrCode;
using ZXing.Common;
using ZXing.QrCode.Internal;

namespace Generate_QRCode
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        /// <summary>
        /// Generate QR code 1
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_Click(object sender, EventArgs e)
        {
            StreamReader sr = new StreamReader(@"C:\Users\Lin\Documents\FInal_Exp\Secert_1.txt");
            StringBuilder sb = new StringBuilder();
            while (!sr.EndOfStream)
                sb.Append(sr.ReadLine());
            textBox1.Text = sb.ToString();
            sr.Close();

            //Generate QR code
            var writer = new BarcodeWriter  //dll裡面可以看到屬性
            {
                Format = BarcodeFormat.QR_CODE,
                Options = new QrCodeEncodingOptions //設定大小
                {
                    ErrorCorrection = ZXing.QrCode.Internal.ErrorCorrectionLevel.L,
                    Height = 500,
                    Width = 500,
                }
            };
            Bitmap aa = writer.Write(sb.ToString());
            aa.Save(@"C:\Users\Lin\Documents\FInal_Exp\Secert_1.jpg");
            pictureBox1.Image = aa; //轉QRcode的文字 

        }
    }
}
