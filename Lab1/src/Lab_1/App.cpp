#include "MainForm.h"

using namespace System;
using namespace System::Windows::Forms;

// точка входа в программу
[STAThread]
int main(array<String^>^ args)
{
    Application::EnableVisualStyles();
    Application::SetCompatibleTextRenderingDefault(false);

    GlycemicApp::MainForm form;
    Application::Run(%form);

    return 0;
}
