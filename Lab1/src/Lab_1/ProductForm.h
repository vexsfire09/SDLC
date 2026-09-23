#pragma once

using namespace System;
using namespace System::Windows::Forms;
using namespace System::Drawing;

namespace GlycemicApp {

    // Вторая форма - для ввода названия продукта
    public ref class ProductForm : public Form
    {
    public:
        ProductForm(void)
        {
            InitializeComponent();
        }

        // через это свойство главная форма передает старый текст
        // и забирает то, что ввел пользователь
        property String^ ProductText
        {
            String^ get() { return txtProduct->Text; }
            void set(String^ value) { txtProduct->Text = value; }
        }

    protected:
        ~ProductForm()
        {
        }

    private:
        TextBox^ txtProduct;
        Button^ btnOk;
        Button^ btnCancel;
        Label^ lblCaption;

        void InitializeComponent(void)
        {
            this->Text = "Ввод продукта";
            this->Size = System::Drawing::Size(320, 160);
            this->StartPosition = FormStartPosition::CenterParent;
            this->FormBorderStyle = System::Windows::Forms::FormBorderStyle::FixedDialog;
            this->MaximizeBox = false;
            this->MinimizeBox = false;

            lblCaption = gcnew Label();
            lblCaption->Location = Point(10, 15);
            lblCaption->Size = System::Drawing::Size(280, 20);
            lblCaption->Text = "Введите название продукта:";
            this->Controls->Add(lblCaption);

            txtProduct = gcnew TextBox();
            txtProduct->Location = Point(10, 40);
            txtProduct->Size = System::Drawing::Size(280, 25);
            this->Controls->Add(txtProduct);

            btnOk = gcnew Button();
            btnOk->Location = Point(50, 80);
            btnOk->Size = System::Drawing::Size(90, 30);
            btnOk->Text = "OK";
            btnOk->Click += gcnew EventHandler(this, &ProductForm::btnOk_Click);
            this->Controls->Add(btnOk);

            btnCancel = gcnew Button();
            btnCancel->Location = Point(160, 80);
            btnCancel->Size = System::Drawing::Size(90, 30);
            btnCancel->Text = "Отмена";
            btnCancel->DialogResult = System::Windows::Forms::DialogResult::Cancel;
            this->Controls->Add(btnCancel);

            this->AcceptButton = btnOk;
            this->CancelButton = btnCancel;
        }

        // проверяем то, что ввел пользователь
        void btnOk_Click(Object^ sender, EventArgs^ e)
        {
            String^ text = txtProduct->Text->Trim();

            // проверка 1 - строка не должна быть пустой
            if (text == "")
            {
                MessageBox::Show(
                    "Название продукта не может быть пустым!",
                    "Ошибка ввода",
                    MessageBoxButtons::OK,
                    MessageBoxIcon::Error);
                return;
            }

            // проверка 2 - в названии должны быть только буквы, пробел и дефис
            bool ok = true;
            for (int i = 0; i < text->Length; i++)
            {
                if (!Char::IsLetter(text[i]) && text[i] != ' ' && text[i] != '-')
                {
                    ok = false;
                    break;
                }
            }

            if (!ok)
            {
                MessageBox::Show(
                    "Название продукта должно содержать только буквы!",
                    "Ошибка ввода",
                    MessageBoxButtons::OK,
                    MessageBoxIcon::Error);
                return;
            }

            // данные верные - закрываем форму с результатом OK
            txtProduct->Text = text;
            this->DialogResult = System::Windows::Forms::DialogResult::OK;
            this->Close();
        }
    };
}
