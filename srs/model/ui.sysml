// Модель системы и пользовательского интерфейса приложения «Двойник» (SysMLv2).
// Содержит контекст системы (DvoinikContext) и структуру основных экранов (DvoinikUI).
package DvoinikModel {
    private import ScalarValues::*;

    // =========================================================================
    // 1. Контекст системы (соответствует схеме context.png)
    // =========================================================================
    package DvoinikContext {
        part def User {
            attribute role : String = "Пользователь Windows 10/11";
        }

        part def SystemPart {
            attribute tech : String;
        }
        part def ExternalElement {
            attribute details : String;
        }

        part def DesktopClient :> SystemPart {
            :>> tech = "Qt 6 Widgets / C++";
        }
        part def SearchAndActionEngine :> SystemPart {
            :>> tech = "3 этапа поиска, защита копий";
        }
        part def SettingsAndLog :> SystemPart {
            :>> tech = "Параметры, журнал действий";
        }
        part def HashCache :> SystemPart {
            :>> tech = "SHA-256 / MD5 (локальный файл)";
        }

        part def FileSystem :> ExternalElement {
            :>> details = "Локальные диски NTFS / FAT32";
        }
        part def RecycleBin :> ExternalElement {
            :>> details = "Windows API (по умолчанию)";
        }
        part def WindowsExplorer :> ExternalElement {
            :>> details = "Открытие файлов / экспорт CSV";
        }

        part def DvoinikSystem {
            part gui : DesktopClient;
            part engine : SearchAndActionEngine;
            part settingsLog : SettingsAndLog;
            part cache : HashCache;

            connection guiToEngine connect gui to engine;
            connection guiToSettings connect gui to settingsLog;
            connection engineToCache connect engine to cache;
        }

        part context {
            part user : User;
            part system : DvoinikSystem;
            part fs : FileSystem;
            part bin : RecycleBin;
            part explorer : WindowsExplorer;

            connection userInteraction connect user to system.gui;
            connection readAndMoveFiles connect system.engine to fs;
            connection moveToTrash connect system.engine to bin;
            connection openInExplorer connect system.engine to explorer;
        }
    }

    // =========================================================================
    // 2. Пользовательский интерфейс (соответствует макетам ui-*.png)
    // =========================================================================
    package DvoinikUI {
        // ---------- базовые элементы управления ----------
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
            part cacheInfo : Label { :>> caption = "Кэш хэшей: 1 420 файлов"; }
        }

        // ---------- экран 1: «Поиск дублей» (настройка поиска) ----------
        part def SearchPage {
            part folders : FolderList { :>> caption = "Папки для поиска"; }
            part addFolder : Button { :>> caption = "Добавить папку"; }
            part subfolders : CheckBox { :>> caption = "Включая подпапки"; }
            part fileTypes : ChipGroup {
                :>> items = ("Все", "Фото", "Видео", "Музыка", "Документы", "Архивы");
            }
            part minSize : SizeField { :>> caption = "от"; }
            part maxSize : SizeField { :>> caption = "до"; }
            part excluded : FolderList { :>> caption = "Исключения"; }
            part addExcluded : Button { :>> caption = "Добавить исключение"; }
            part startButton : Button { :>> caption = "Начать поиск"; }
        }

        // ---------- экран 2: «Ход сканирования» ----------
        part def ScanPage {
            part stage1 : Label { :>> caption = "1. По размеру"; }
            part stage2 : Label { :>> caption = "2. По началу файла"; }
            part stage3 : Label { :>> caption = "3. Полный хэш (SHA-256)"; }
            part progress : ProgressBar;
            part currentFile : Label;
            part checkedCount : Counter { :>> caption = "Проверено файлов"; }
            part groupsFound : Counter { :>> caption = "Найдено групп"; }
            part canFree : Label { :>> caption = "Можно освободить"; }
            part elapsed : Label { :>> caption = "Прошло времени"; }
            part pauseButton : Button { :>> caption = "Пауза"; }
            part cancelButton : Button { :>> caption = "Отмена"; }
        }

        // ---------- экран 3: «Результаты поиска» ----------
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
            part openButton : Button { :>> caption = "Открыть файл"; }
            part explorerButton : Button { :>> caption = "Показать в проводнике"; }
        }
        part def ResultsPage {
            part summary : Label { :>> caption = "Найдено 34 группы, можно освободить 1,42 ГБ"; }
            part autoSelect : ComboBox {
                :>> caption = "Автовыбор";
                :>> items = ("Оставить самый новый", "Оставить самый старый",
                             "Оставить с коротким путём", "Оставить из папки");
            }
            part exportCsv : Button { :>> caption = "Экспорт CSV"; }
            part newSearch : Button { :>> caption = "Новый поиск"; }
            part groups : DuplicateGroup [0..*];
            part preview : PreviewPanel;
            part moveButton : Button { :>> caption = "Переместить..."; }
            part deleteButton : Button { :>> caption = "Удалить навсегда"; }
            part trashButton : Button { :>> caption = "В корзину"; }
        }

        // ---------- экран 4: «Сравнение папок» ----------
        part def ComparePage {
            part folderA : FolderPicker { :>> caption = "Папка A (оригинал)"; }
            part folderB : FolderPicker { :>> caption = "Папка B (резерв)"; }
            part subfolders : CheckBox { :>> caption = "Включая подпапки"; }
            part compareButton : Button { :>> caption = "Сравнить папки"; }
            part inBoth : Counter { :>> caption = "Есть в обеих"; }
            part onlyA : Counter { :>> caption = "Только в папке A"; }
            part onlyB : Counter { :>> caption = "Только в папке B"; }
            part matches : Table;
            part exportCsv : Button { :>> caption = "Экспорт отчёта (CSV)"; }
        }

        // ---------- главное окно ----------
        part def MainWindow {
            attribute title : String = "Двойник";
            part nav : NavigationPanel;
        }
        part searchWindow : MainWindow { part page : SearchPage; }
        part scanWindow : MainWindow { part page : ScanPage; }
        part resultsWindow : MainWindow { part page : ResultsPage; }
        part compareWindow : MainWindow { part page : ComparePage; }
    }
}
