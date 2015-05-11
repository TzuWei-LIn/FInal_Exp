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
            StreamReader sr = new StreamReader(@"C:\Users\Lin\Documents\FInal_Exp\Secert_1_1.txt");
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
                    Height = 250,
                    Width = 250,
                }
            };
            Bitmap aa = writer.Write(sb.ToString());
            aa.Save(@"C:\Users\Lin\Documents\FInal_Exp\Secert_1.jpg");
            pictureBox1.Image = aa; //轉QRcode的文字 

        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            ZXing.IBarcodeReader reader = new ZXing.BarcodeReader();
            FileStream fs = new FileStream(@"C:\Users\Lin\Documents\FInal_Exp\Secert_1.jpg", FileMode.Open);
            //FileStream fs = new FileStream(@"C:\Users\Lin\Documents\FInal_Exp\Secert_2.jpg", FileMode.Open);
            Byte[] data = new byte[fs.Length];
            fs.Read(data, 0, data.Length);
            fs.Close();
            MemoryStream ms = new MemoryStream(data);
            Bitmap b = (Bitmap)Image.FromStream(ms);
            ZXing.Result rr = reader.Decode(b);
            if (rr != null) 
                textBox1.Text = rr.Text;
            else 
                MessageBox.Show("Fail");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            StreamReader sr = new StreamReader(@"C:\Users\Lin\Documents\FInal_Exp\Secert_2_2.txt");
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
                    Height = 250,
                    Width = 250,
                }
            };
            Bitmap aa = writer.Write(sb.ToString());
            aa.Save(@"C:\Users\Lin\Documents\FInal_Exp\Secert_2.jpg");
            pictureBox1.Image = aa; //轉QRcode的文字 
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            ZXing.IBarcodeReader reader = new ZXing.BarcodeReader();
            FileStream fs = new FileStream(@"C:\Users\Lin\Documents\FInal_Exp\Secert_2.jpg", FileMode.Open);
            Byte[] data = new byte[fs.Length];
            fs.Read(data, 0, data.Length);
            fs.Close();
            MemoryStream ms = new MemoryStream(data);
            Bitmap b = (Bitmap)Image.FromStream(ms);
            ZXing.Result rr = reader.Decode(b);
            if (rr != null)
                textBox1.Text = rr.Text;
            else
                MessageBox.Show("Fail");
        }
    }
}
