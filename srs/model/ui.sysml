// Модель пользовательского интерфейса приложения «Двойник» (SysMLv2, текстовая нотация).
// Экран описывается иерархией частей: окно -> боковое меню и страница раздела -> элементы управления.
// Значение атрибута caption (text) — надпись, которую видит пользователь.
package DvoinikUI {
    private import ScalarValues::*;

    // ---------- элементы управления ----------
    part def Widget { attribute caption : String; }
    part def Button :> Widget;
    part def CheckBox :> Widget;
    part def ComboBox :> Widget { attribute items : String [0..*]; }
    part def ChipGroup :> Widget { attribute items : String [0..*]; }
    part def SizeField :> Widget { attribute value : Real; }
    part def Label :> Widget;
    part def FolderList :> Widget { attribute paths : String [0..*]; }
    part def Image :> Widget;
    part def ProgressBar :> Widget { attribute percent : Real; }
    part def Counter :> Label { attribute count : Integer; }
    part def FolderPicker :> Widget { attribute path : String; }
    part def Table :> Widget;

    // ---------- боковое меню ----------
    part def NavigationPanel {
        part searchItem : Button { :>> caption = "Поиск дублей"; }
        part compareItem : Button { :>> caption = "Сравнение папок"; }
        part settingsItem : Button { :>> caption = "Настройки"; }
    }

    // ---------- раздел «Поиск дублей»: настройка поиска ----------
    part def SearchPage {
        part folders : FolderList { :>> caption = "Где искать дубликаты"; }
        part addFolder : Button { :>> caption = "Добавить папку"; }
        part subfolders : CheckBox { :>> caption = "Включая подпапки"; }
        part fileTypes : ChipGroup {
            :>> items = ("Все", "Фото", "Видео", "Музыка", "Документы", "Архивы");
        }
        part minSize : SizeField { :>> caption = "от"; }
        part maxSize : SizeField { :>> caption = "до"; }
        part excluded : FolderList { :>> caption = "Не проверять"; }
        part cacheInfo : Label { :>> caption = "В кэше N файлов"; }
        part startButton : Button { :>> caption = "Начать поиск"; }
    }

    // ---------- раздел «Поиск дублей»: результаты ----------
    part def FileRow {
        part checked : CheckBox;
        attribute path : String;
        attribute modified : String;
        attribute keep : Boolean;
    }
    part def DuplicateGroup {
        attribute fileName : String;
        attribute copySize : Integer;
        part files : FileRow [2..*];
        part warning : Label { :>> caption = "Нужно оставить хотя бы одну копию"; }
    }
    part def PreviewPanel {
        part thumbnail : Image;
        part openButton : Button { :>> caption = "Открыть"; }
        part explorerButton : Button { :>> caption = "В проводнике"; }
    }
    part def ResultsPage {
        part summary : Label { :>> caption = "Найдено N групп, можно освободить X"; }
        part newSearch : Button { :>> caption = "Новый поиск"; }
        part autoSelect : ComboBox {
            :>> caption = "Автовыбор";
            :>> items = ("Оставить самый новый", "Оставить самый старый",
                         "Оставить с коротким путём", "Оставить из папки");
        }
        part exportCsv : Button { :>> caption = "Экспорт CSV"; }
        part groups : DuplicateGroup [0..*];
        part preview : PreviewPanel;
        part selection : Label { :>> caption = "Отмечено N файлов"; }
        part moveButton : Button { :>> caption = "Переместить…"; }
        part deleteButton : Button { :>> caption = "Удалить навсегда"; }
        part trashButton : Button { :>> caption = "В корзину"; }
    }

    // ---------- раздел «Поиск дублей»: ход сканирования ----------
    part def ScanPage {
        part stage1 : Label { :>> caption = "1. По размеру"; }
        part stage2 : Label { :>> caption = "2. По началу файла"; }
        part stage3 : Label { :>> caption = "3. Полная проверка"; }
        part progress : ProgressBar;
        part currentFile : Label;
        part checkedCount : Counter { :>> caption = "Проверено файлов"; }
        part groupsFound : Counter { :>> caption = "Найдено групп"; }
        part canFree : Label { :>> caption = "Можно освободить"; }
        part elapsed : Label { :>> caption = "Прошло"; }
        part pauseButton : Button { :>> caption = "Пауза"; }
        part cancelButton : Button { :>> caption = "Отмена"; }
    }

    // ---------- раздел «Сравнение папок» ----------
    part def ComparePage {
        part folderA : FolderPicker { :>> caption = "A"; }
        part folderB : FolderPicker { :>> caption = "B"; }
        part compareButton : Button { :>> caption = "Сравнить"; }
        part inBoth : Counter { :>> caption = "Есть в обеих"; }
        part onlyA : Counter { :>> caption = "Только в A"; }
        part onlyB : Counter { :>> caption = "Только в B"; }
        part matches : Table;
        part exportCsv : Button { :>> caption = "Экспорт CSV"; }
    }

    // ---------- раздел «Настройки» ----------
    part def SettingsPage {
        part useCache : CheckBox { :>> caption = "Запоминать хэши проверенных файлов"; }
        part cacheInfo : Label { :>> caption = "N файлов, X МБ"; }
        part clearCache : Button { :>> caption = "Очистить кэш"; }
        part autoSelectRule : ComboBox { :>> caption = "Правило автовыбора"; }
        part defaultAction : ComboBox {
            :>> caption = "Действие по умолчанию";
            :>> items = ("В корзину", "Переместить в папку");
        }
        part hashAlgorithm : ComboBox {
            :>> caption = "Алгоритм хэша";
            :>> items = ("SHA-256", "MD5");
        }
        part hiddenFiles : CheckBox { :>> caption = "Проверять скрытые и системные файлы"; }
    }

    // ---------- окно подтверждения действия ----------
    part def ConfirmDialog {
        part question : Label { :>> caption = "Переместить в корзину?"; }
        part summary : Label { :>> caption = "Будет перемещено N файлов из M групп, освободится X"; }
        part safety : Label { :>> caption = "В каждой группе остаётся хотя бы одна копия"; }
        part cancelButton : Button { :>> caption = "Отмена"; }
        part confirmButton : Button { :>> caption = "В корзину"; }
    }

    // ---------- главное окно ----------
    part def MainWindow {
        attribute title : String = "Двойник";
        part nav : NavigationPanel;
    }
    part searchWindow : MainWindow {
        part page : SearchPage;
    }
    part resultsWindow : MainWindow {
        part page : ResultsPage;
    }
    part scanWindow : MainWindow {
        part page : ScanPage;
    }
    part compareWindow : MainWindow {
        part page : ComparePage;
    }
    part settingsWindow : MainWindow {
        part page : SettingsPage;
    }
    part confirmDialog : ConfirmDialog;
}
