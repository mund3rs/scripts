import sqlite3
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from datetime import date


# Database setup (for demonstration purposes)
def setup_database():
    conn = sqlite3.connect('invoice.db')
    c = conn.cursor()
    c.execute('''
        CREATE TABLE IF NOT EXISTS invoices (
            id INTEGER PRIMARY KEY,
            customer_name TEXT,
            customer_address TEXT,
            items TEXT
        )
    ''')
    # Sample data to mimic the uploaded invoice structure
    c.execute('''
        INSERT INTO invoices (customer_name, customer_address, items)
        VALUES ('ABC Company', 'XYZ Buyer\\nClient Location\\nStreet, City\\nUK', 
                'Wordpress Design & Development:1:8000:8000,Shopify Web Building:25:70:1750,Chrome Extension Development:1:5000:5000,Redesign a Service Site:30:45:1350')
    ''')
    conn.commit()
    conn.close()


def fetch_invoice_data():
    conn = sqlite3.connect('invoice.db')
    c = conn.cursor()
    c.execute('SELECT * FROM invoices WHERE id = 1')
    invoice_data = c.fetchone()
    conn.close()
    return invoice_data


def draw_multiline_text(pdf, text, x, y):
    # Helper function to handle multiline text
    line_height = 14
    for line in text.split('\\n'):
        pdf.drawString(x, y, line)
        y -= line_height
    return y  # return the last y position


# PDF generation with ReportLab
def create_pdf(invoice_data):
    customer_name, customer_address, items = invoice_data[1:]
    my_address = "Web Developer\\nABC Seller\\nWeb Developer Location\\nStreet, City\\nUK\\nemail@email.com"

    pdf = canvas.Canvas("web_developer_invoice.pdf", pagesize=letter)
    width, height = letter

    # Header - Logo Placeholder
    pdf.setFont("Helvetica-Bold", 16)
    pdf.drawString(50, height - 40, "Logo")

    # Addresses
    pdf.setFont("Helvetica", 12)
    pdf.drawString(50, height - 100, "Your details\\nFROM")
    last_y_position = draw_multiline_text(pdf, my_address, 50, height - 120)
    pdf.drawString(350, height - 100, "Client's details\\nTO")
    draw_multiline_text(pdf, customer_address, 350, height - 120)

    # Invoice Details
    pdf.drawString(50, last_y_position - 40, f"Invoice No: 012345")
    pdf.drawString(50, last_y_position - 60, "Invoice Date: Dec 14th, 2021")
    pdf.drawString(350, last_y_position - 40, "Due Date: Dec 31st, 2021")

    # Items Table
    y_position = last_y_position - 100
    pdf.setFillColor(colors.lightgrey)
    pdf.rect(50, y_position, 500, 25, fill=True, stroke=False)
    pdf.setFillColor(colors.black)
    pdf.drawString(60, y_position + 5, "Item")
    pdf.drawString(260, y_position + 5, "HRS/Qty")
    pdf.drawString(360, y_position + 5, "Rate")
    pdf.drawString(460, y_position + 5, "Subtotal")

    # List items
    y_position -= 20
    total = 0
    for item in items.split(','):
        description, qty, rate, subtotal = item.split(':')
        pdf.drawString(60, y_position, description)
        pdf.drawString(260, y_position, qty)
        pdf.drawString(360, y_position, f"${rate}")
        pdf.drawString(460, y_position, f"${subtotal}")
        total += float(subtotal)
        y_position -= 20

    # Invoice Summary
    pdf.drawString(350, y_position - 40, "Invoice Summary")
    pdf.drawString(460, y_position - 60, f"${total:.2f}")
    pdf.drawString(460, y_position - 80, f"${total:.2f}")

    # Footer
    pdf.setFont("Helvetica-Oblique", 10)
    pdf.drawString(50, 50, "Thank you for your business. Please contact us for any further needs.")

    pdf.save()


def main():
    setup_database()
    invoice_data = fetch_invoice_data()
    create_pdf(invoice_data)


if __name__ == "__main__":
    main()