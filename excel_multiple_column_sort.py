# Сортировка нескольких столбцов Excel в заданном диапазоне (количество столбцов и строк, начиная с ячейки A1).

import win32com.client as wc
from string import ascii_lowercase

xlApp = wc.Dispatch("Excel.Application").Sheets("Work")


# Создание буквенной последовательности A-ZZZ
def sequence():
    letter_sequence = []

    for c in ascii_lowercase:
        letter_sequence.append(c.upper())

    for c1 in ascii_lowercase:
        for c2 in ascii_lowercase:
            c = c1.upper() + c2.upper()
            letter_sequence.append(c)

    for c1 in ascii_lowercase:
        for c2 in ascii_lowercase:
            for c3 in ascii_lowercase:
                c = c1.upper() + c2.upper() + c3.upper()
                letter_sequence.append(c)

    return letter_sequence


# Направление сортировки: 1 - по возрастанию, 2 - по убыванию
xlAscending = 2

# Количество столбцов
columns = 11
# Количество строк
lines = 15

lst = sequence()

# Сортировка по столбцам
for i in range(columns):
    z1 = lst[i] + str(1) + ':' + lst[i] + str(lines)
    z2 = lst[i] + str(1)
    xlApp.Range(z1).Sort(Key1=xlApp.Range(z2), Order1=xlAscending)
