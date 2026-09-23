#pragma once

#include "ProductForm.h"

using namespace System;
using namespace System::Windows::Forms;
using namespace System::Drawing;

namespace GlycemicApp {

    // Главная форма программы
    public ref class MainForm : public Form
    {
    public:
        MainForm(void)
        {
            InitializeComponent();
            lastProduct = ""; // тут будем хранить последний введенный продукт

            // простая "база данных" продуктов и их гликемического индекса
            productNames = gcnew array<String^> {
                "рис", "хлеб", "яблоко", "банан", "картофель",
                "гречка", "морковь", "молоко", "сахар", "арбуз",
                "салат", "киви"
            };
            productGI = gcnew array<int> {
                70, 85, 35, 60, 90,
                50, 35, 30, 100, 75, 
                60, 25
            };
        }

    protected:
        ~MainForm()
        {
        }

    private:
        Label^ lblInfo;
        Label^ lblProductCaption;
        Label^ lblProductName;
        Label^ lblResultCaption;
        Label^ lblResult;
        Button^ btnEnter;

        String^ lastProduct; // память о последнем введенном значении

        // "база данных" продуктов и их гликемического индекса
        // (заполняется в конструкторе)
        array<String^>^ productNames;
        array<int>^ productGI;

        void InitializeComponent(void)
        {
            this->Text = "Гликемический индекс продуктов";
            this->Size = System::Drawing::Size(420, 300);
            this->StartPosition = FormStartPosition::CenterScreen;

            // определение понятия ГИ
            lblInfo = gcnew Label();
            lblInfo->Location = Point(10, 10);
            lblInfo->Size = System::Drawing::Size(390, 90);
            lblInfo->Text =
                "Гликемический индекс (ГИ) - показатель влияния продукта\r\n"
                "на уровень глюкозы в крови после его употребления.\r\n"
                "Чем выше ГИ, тем быстрее продукт повышает сахар в крови.\r\n"
                "Значения ГИ находятся в диапазоне от 0 до 100.";
            this->Controls->Add(lblInfo);

            btnEnter = gcnew Button();
            btnEnter->Location = Point(10, 110);
            btnEnter->Size = System::Drawing::Size(150, 30);
            btnEnter->Text = "Ввести продукт";
            btnEnter->Click += gcnew EventHandler(this, &MainForm::btnEnter_Click);
            this->Controls->Add(btnEnter);

            lblProductCaption = gcnew Label();
            lblProductCaption->Location = Point(10, 160);
            lblProductCaption->Size = System::Drawing::Size(120, 20);
            lblProductCaption->Text = "Продукт:";
            this->Controls->Add(lblProductCaption);

            lblProductName = gcnew Label();
            lblProductName->Location = Point(140, 160);
            lblProductName->Size = System::Drawing::Size(250, 20);
            lblProductName->Text = "";
            this->Controls->Add(lblProductName);

            lblResultCaption = gcnew Label();
            lblResultCaption->Location = Point(10, 190);
            lblResultCaption->Size = System::Drawing::Size(160, 20);
            lblResultCaption->Text = "Гликемический индекс:";
            this->Controls->Add(lblResultCaption);

            lblResult = gcnew Label();
            lblResult->Location = Point(180, 190);
            lblResult->Size = System::Drawing::Size(100, 20);
            lblResult->Font = gcnew System::Drawing::Font(lblResult->Font, FontStyle::Bold);
            lblResult->Text = "";
            this->Controls->Add(lblResult);
        }

        // нажатие на кнопку "Ввести продукт"
        void btnEnter_Click(Object^ sender, EventArgs^ e)
        {
            ProductForm^ form = gcnew ProductForm();

            // восстанавливаем то, что было введено в прошлый раз
            form->ProductText = lastProduct;

            if (form->ShowDialog() == System::Windows::Forms::DialogResult::OK)
            {
                // запоминаем новое значение, чтобы восстановить в следующий раз
                lastProduct = form->ProductText;

                ShowResult(lastProduct);
            }
        }

        // поиск ГИ введенного продукта в "базе" и вывод результата
        void ShowResult(String^ name)
        {
            lblProductName->Text = name;

            String^ nameLower = name->Trim()->ToLower();
            int found = -1;

            for (int i = 0; i < productNames->Length; i++)
            {
                if (productNames[i] == nameLower)
                {
                    found = i;
                    break;
                }
            }

            if (found == -1)
            {
                lblResult->Text = "-";
                MessageBox::Show(
                    "Продукт \"" + name + "\" не найден в базе данных.\n"
                    "Попробуйте ввести другой продукт (например: рис, хлеб, яблоко, банан...).",
                    "Ошибка",
                    MessageBoxButtons::OK,
                    MessageBoxIcon::Error);
            }
            else
            {
                lblResult->Text = productGI[found].ToString();
            }
        }
    };
}
