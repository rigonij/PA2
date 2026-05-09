package lib

import (
	"bytes"
	"fmt"

	"github.com/go-pdf/fpdf"
)

type InvoiceLine struct {
	Label  string
	Detail string
	Amount float64
}

type InvoiceData struct {
	Ref      string
	Date     string
	Title    string
	Subtitle string
	Lines    []InvoiceLine
	Total    float64
	Footer   string
}

func BuildInvoicePDF(data InvoiceData) ([]byte, error) {
	pdf := fpdf.New("P", "mm", "A4", "")
	pdf.SetMargins(15, 15, 15)
	pdf.AddPage()
	tr := pdf.UnicodeTranslatorFromDescriptor("")

	pdf.SetFont("Arial", "B", 22)
	pdf.SetTextColor(184, 134, 11)
	pdf.Cell(0, 10, tr(data.Title))
	pdf.Ln(8)

	pdf.SetFont("Arial", "", 11)
	pdf.SetTextColor(110, 110, 110)
	pdf.Cell(0, 6, tr(data.Subtitle))
	pdf.Ln(10)

	pdf.SetDrawColor(184, 134, 11)
	pdf.SetLineWidth(0.6)
	pdf.Line(15, pdf.GetY(), 195, pdf.GetY())
	pdf.Ln(6)

	pdf.SetTextColor(50, 50, 50)
	pdf.SetFont("Arial", "B", 11)
	pdf.Cell(30, 7, tr("Référence :"))
	pdf.SetFont("Arial", "", 11)
	pdf.Cell(0, 7, tr(data.Ref))
	pdf.Ln(6)

	pdf.SetFont("Arial", "B", 11)
	pdf.Cell(30, 7, tr("Date :"))
	pdf.SetFont("Arial", "", 11)
	pdf.Cell(0, 7, tr(data.Date))
	pdf.Ln(12)

	pdf.SetFillColor(245, 245, 245)
	pdf.SetTextColor(80, 80, 80)
	pdf.SetFont("Arial", "B", 10)
	pdf.CellFormat(70, 8, tr("Objet"), "B", 0, "L", true, 0, "")
	pdf.CellFormat(80, 8, tr("Détail"), "B", 0, "L", true, 0, "")
	pdf.CellFormat(30, 8, tr("Montant"), "B", 0, "R", true, 0, "")
	pdf.Ln(8)

	pdf.SetTextColor(40, 40, 40)
	pdf.SetFont("Arial", "", 10)
	for _, line := range data.Lines {
		pdf.CellFormat(70, 8, tr(line.Label), "B", 0, "L", false, 0, "")
		pdf.CellFormat(80, 8, tr(line.Detail), "B", 0, "L", false, 0, "")
		pdf.CellFormat(30, 8, tr(formatAmount(line.Amount)+" €"), "B", 0, "R", false, 0, "")
		pdf.Ln(8)
	}

	pdf.Ln(6)
	pdf.SetFont("Arial", "B", 13)
	pdf.SetTextColor(184, 134, 11)
	pdf.CellFormat(180, 10, tr("Total : "+formatAmount(data.Total)+" €"), "", 0, "R", false, 0, "")
	pdf.Ln(20)

	pdf.SetFont("Arial", "I", 9)
	pdf.SetTextColor(150, 150, 150)
	pdf.MultiCell(0, 5, tr(data.Footer), "", "L", false)

	var buf bytes.Buffer
	if err := pdf.Output(&buf); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

func formatAmount(v float64) string {
	return fmt.Sprintf("%.2f", v)
}

type ProviderRecapField struct {
	Label string
	Value string
}

type ProviderRecapData struct {
	ID      int
	DateSub string
	Fields  []ProviderRecapField
	Amount  float64
	Footer  string
}

func BuildProviderRecapPDF(data ProviderRecapData) ([]byte, error) {
	pdf := fpdf.New("P", "mm", "A4", "")
	pdf.SetMargins(15, 15, 15)
	pdf.AddPage()
	tr := pdf.UnicodeTranslatorFromDescriptor("")

	pdf.SetFont("Arial", "B", 20)
	pdf.SetTextColor(40, 40, 40)
	pdf.Cell(0, 10, tr(fmt.Sprintf("Récapitulatif intervention #%d", data.ID)))
	pdf.Ln(8)

	pdf.SetFont("Arial", "", 11)
	pdf.SetTextColor(110, 110, 110)
	pdf.Cell(0, 6, tr("Date : "+data.DateSub))
	pdf.Ln(12)

	pdf.SetFillColor(245, 245, 245)
	pdf.SetTextColor(80, 80, 80)
	pdf.SetFont("Arial", "B", 10)
	pdf.CellFormat(60, 8, tr("Champ"), "B", 0, "L", true, 0, "")
	pdf.CellFormat(120, 8, tr("Valeur"), "B", 0, "L", true, 0, "")
	pdf.Ln(8)

	pdf.SetTextColor(40, 40, 40)
	for _, f := range data.Fields {
		pdf.SetFont("Arial", "B", 10)
		pdf.CellFormat(60, 8, tr(f.Label), "B", 0, "L", false, 0, "")
		pdf.SetFont("Arial", "", 10)
		pdf.CellFormat(120, 8, tr(f.Value), "B", 0, "L", false, 0, "")
		pdf.Ln(8)
	}

	pdf.Ln(8)
	pdf.SetFont("Arial", "B", 14)
	pdf.SetTextColor(40, 40, 40)
	pdf.Cell(0, 10, tr(fmt.Sprintf("Montant : %.2f €", data.Amount)))
	pdf.Ln(20)

	if data.Footer != "" {
		pdf.SetFont("Arial", "I", 9)
		pdf.SetTextColor(150, 150, 150)
		pdf.MultiCell(0, 5, tr(data.Footer), "", "L", false)
	}

	var buf bytes.Buffer
	if err := pdf.Output(&buf); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
