using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.Reporting.WebForms;
using System.IO;

namespace VeClient
{
    public class ReportHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string filtro = context.Request.QueryString["filtro"];
            if (string.IsNullOrEmpty(filtro)) filtro = null;

            DataTable dt = new DataTable();
            string connString = ConfigurationManager.ConnectionStrings["VeClientDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("sp_GetAllSeVeClie_Report", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@FilterValue", (object)filtro ?? DBNull.Value);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            LocalReport lr = new LocalReport();
            lr.ReportPath = context.Server.MapPath("~/Reports/rptSeVeClie.rdlc");
            lr.DataSources.Add(new ReportDataSource("DataSet1", dt));

            string mimeType;
            string encoding;
            string fileNameExtension;
            Warning[] warnings;
            string[] streams;

            byte[] renderedBytes = lr.Render("PDF", null, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);

            // 4. Salida al navegador
            context.Response.Clear();
            context.Response.ContentType = mimeType;
            context.Response.AddHeader("content-disposition", "inline; filename=ReporteClientes.pdf");
            context.Response.BinaryWrite(renderedBytes);
            context.Response.End();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}