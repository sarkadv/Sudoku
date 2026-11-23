# Sudoku

Hra sudoku pro iPhone a iPad, napsaná ve Swiftu se SwiftUI.

## Funkce

- **Tři obtížnosti** (lehká, střední, těžká) a krátké **demo** sudoku.
- **Pokaždé jiné sudoku.** Zadání jsou uložená jako mřížky písmen v souboru `sudokus.csv`. Při každé hře se
  písmena náhodně přiřadí číslům a mřížka se náhodně otočí a překlopí, takže z jednoho uloženého zadání může
  vzniknout mnoho různých her.
- **Nástroje:** tužka pro poznámky (kandidáty), zvýrazňovač a gumy na hodnoty a zvýraznění.
- **Pokračování v nedohrané hře.** Rozehraná hra se uloží, když aplikace přejde do pozadí, a lze se k ní vrátit
  z menu.
- **Časomíra** a nejlepší čas pro každou obtížnost.
- **Zvuky přírody:** les, oceán, déšť a řeka.
- **Barevné režimy:** automatický (podle systému), světlý, tmavý a pastelový.
- **Čeština a angličtina.**
- Funguje na výšku i na šířku.

## Spuštění

1. Otevřete `Sudoku.xcodeproj` v Xcode.
2. Vyberte simulátor nebo zařízení iPhone či iPad se systémem iOS 18.2 nebo novějším.
3. Stiskněte **Run**.

## Struktura projektu

| Složka             | Obsah                                                                  |
| ------------------ | ---------------------------------------------------------------------- |
| `Views`            | Obrazovky ve SwiftUI: menu, hra, nastavení, obrazovka výhry            |
| `Model`            | Herní plocha, buňka a časomíra                                         |
| `SudokuGenerator`  | Načtení zadání z CSV a jejich převod na hratelné sudoku                |
| `Managers`         | Ukládání stavu, jazyk, barevný režim a zvuk                            |
| `Enums`, `Helpers` | Obtížnosti, barevné režimy, typy zvuků; pomocné funkce pro matice, čas a řetězce |
| `Resources`        | CSV se zadáními, zvuky, obrázky                                        |
| `Constants`        | Barvy a lokalizované texty                                             |
