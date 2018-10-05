import datetime
import os
import shutil
import psutil

def term_length(line):
    action = 'COUNT'
    cursor = 0
    counter = 0

    for char in line:
        if   action == 'COUNT' and char == '\u001B':
            action = 'SKIP'
        elif action == 'SKIP'  and char == 'm':
            action = 'COUNT'
        elif action == 'COUNT':
            counter += 1

    return counter

def get_term_width():
    return shutil.get_terminal_size((37, 0)).columns

def print_with_cut(line):
    line_length = get_term_width()

    action = 'PRINT'
    counter = 0
    for char in line:
        if   action == 'PRINT' and char == '\u001B':
            action = 'SKIP'
        elif action == 'SKIP'  and char == 'm':
            action = 'PRINT'
        elif action == 'PRINT':
            counter += 1

            if counter > line_length: break

        print(char, end='')

    print('')

def print_center(*lines):
    max_length  = max(term_length(line) for line in lines)
    line_length = get_term_width()
    margin_left = ' ' * round((line_length - max_length) / 2)

    for line in lines:
        print_with_cut(margin_left + line)

def get_fillers_for_table(table):
    table_rows = len(table)
    table_columns = len(table[0])

    fillers = [["" for _ in range(table_columns)] for _ in range(table_rows)]

    for column in range(table_columns):
        max_cell_in_column = 0

        for row in range(table_rows):
            cell = table[row][column]
            cell_length = term_length(cell)

            max_cell_in_column = max(max_cell_in_column, cell_length)

        for row in range(table_rows):
            cell = table[row][column]
            cell_length = term_length(cell)

            filler_length = max_cell_in_column - cell_length
            fillers[row][column] = ' ' * filler_length

    return fillers

def print_table(table, justifiers):
    fillers = get_fillers_for_table(table)

    lines = []
    for r, row in enumerate(table):
        line = ''
        for c, cell in enumerate(row):
            filler = fillers[r][c]
            justify = justifiers[c]

            if justify == 'LEFT':
                line += cell + filler + ' '
            else:
                line += filler + cell + ' '

        lines.append(line)

    print_center(*lines)

def show_banner():
    print_center(
        '\u001B[31m __ __ _____ __ __ _____ ___ _ _____ _____ ',
        '\u001B[31m|  |  |  ___|  |  |  ___|   | |_   _|     |',
        '\u001B[31m|     |  ___|     |  ___|     | | | |  -  |',
        '\u001B[35m|_|_|_|_____|_|_|_|_____|_|___| |_| |_____|',
    )

    print_center(
        '\u001B[35m __ __ _____ ____ _____ ',
        '\u001B[35m|  |  |     | __ \_   _|',
        '\u001B[33m|     |  -  |    <_| |_ ',
        '\u001B[33m|_|_|_|_____|_|__|_____|',
    )

    print_center(
        '\u001B[32m ____ _____ ____ ____ _____ ',
        '\u001B[32m|    |  _  | __ \ __ \  ___|',
        '\u001B[32m| ---|     |    <  __/  ___|',
        '\u001B[34m|____|__|__|_|__|_|  |_____|',
    )

    print_center(
        '\u001B[34m ___ _____ _____ __ __ ',
        '\u001B[34m|   \_   _|  ___|  |  |',
        '\u001B[36m| -  || |_|  ___|     |',
        '\u001B[36m|___/_____|_____|_|_|_|',
    )

    print()

def get_uptime():
    with open('/proc/uptime', 'r') as f:
        line = f.readline()
        seconds = float(line.split(' ')[0])
        result = datetime.timedelta(seconds = seconds)

    return result

def format_uptime(uptime):
    if uptime.days > 0:
        result = '%d days, ' % uptime.days
    else:
        result = ''

    minutes = uptime.seconds / 60 % 60
    hours = uptime.seconds / 60 / 60 % 24

    result += '%d:%02d' % (hours, minutes)

    return result

def show_uptime():
    uptime = format_uptime(get_uptime())

    print_center('\u001B[34mup: \u001B[36m' + uptime)
    print()

def get_device_short_name(long_name):
    if   '/dev/sd' in long_name:
        return long_name[-4:]
    elif '/dev/mapper' in long_name:
        return long_name.split('-')[-1]
    elif '/dev/' in long_name:
        return long_name[5:]
    else:
        return long_name

def get_color_by_usage(usage):
    factor = usage.used / usage.total
    if factor > 0.8:
        return '\u001B[31m' # red
    if factor > 0.7:
        return '\u001B[35m' # orange
    if factor > 0.6:
        return '\u001B[33m' # yellow
    if factor > 0.5:
        return '\u001B[36m' # magenta
    if factor > 0.4:
        return '\u001B[34m' # blue

    return '\u001B[32m' # green

def draw_bar(factor, color, length):
    gray  = '\u001B[1;30m'
    reset = '\u001B[0m'

    active = round(length * factor)
    inactive = length - active

    return '[' + color + '=' * active + gray + '=' * inactive + reset + ']'

def draw_resource_bar(factor):
    color = get_color_by_load(factor)
    length = round(get_term_width() / 8 + 4)

    return draw_bar(factor, color, length)

def draw_disk_bar(usage):
    factor = usage.used / usage.total
    color = get_color_by_usage(usage)
    length = round(get_term_width() / 8 + 4)

    return draw_bar(factor, color, length)

def bytes_to_human(v):
    units = ['b', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb']
    u = 0
    while v >= 1000:
        v /= 1000
        u += 1

    return "%.2f %s" % (v, units[u])

def format_disk_usage(usage):
    color = get_color_by_usage(usage)
    reset = '\u001B[0m'

    used = bytes_to_human(usage.used)
    total = bytes_to_human(usage.total)

    return color + used + reset + ' / ' + total

def partitions_to_table(partitions):
    table = []
    for partition in partitions:
        name = '\u001B[0m' + get_device_short_name(partition.device)
        try:
            raw_usage = shutil.disk_usage(partition.mountpoint)
            bar = draw_disk_bar(raw_usage)
            usage = format_disk_usage(raw_usage)
        except PermissionError:
            bar   = '\u001B[31m?\u001B[0m'
            usage = '\u001B[31m?\u001B[0m'

        table.append([name, bar, usage])

    return table

def get_space_lines():
    partitions = psutil.disk_partitions()
    return partitions_to_table(partitions)

def get_color_by_load(load):
    if load > 0.7:
        return '\u001B[31m' # red
    if load > 0.6:
        return '\u001B[35m' # orange
    if load > 0.5:
        return '\u001B[33m' # yellow
    if load > 0.4:
        return '\u001B[36m' # magenta
    if load > 0.3:
        return '\u001B[34m' # blue

    return '\u001B[32m' # green

def get_cpu_line():
    cpu_load = os.getloadavg()[0] / os.cpu_count()
    color = get_color_by_load(cpu_load)

    bar = draw_resource_bar(cpu_load)
    val = color + '%.0f%%' % (cpu_load * 100) + '\u001B[0m'

    return ['cpu:', bar, val]

def get_mem_line():
    vmem = psutil.virtual_memory()
    mem_load = vmem.used / vmem.total
    color = get_color_by_load(mem_load)

    bar = draw_resource_bar(mem_load)
    val = color + bytes_to_human(vmem.used) + '\u001B[0m / ' + bytes_to_human(vmem.total)

    return ['mem:', bar, val]

def show_resources():
    table = get_space_lines()
    table.append(['', '', ''])
    table.append(get_cpu_line())
    table.append(get_mem_line())

    print_table(table, ['RIGHT', 'LEFT', 'LEFT'])
    print()

def fin():
    print('\u001B[0m', end='')

show_banner()
show_uptime()
show_resources()
fin()
