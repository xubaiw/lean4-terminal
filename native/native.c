#include <stdio.h>
#include <stdint.h>
#ifndef _WIN32
#include <unistd.h>
#include <sys/ioctl.h>
#include <termios.h>
#else
#include <windows.h>
#include <io.h>
#endif
#include <lean/lean.h>

#ifndef _WIN32

struct termios orig_termios;
int is_raw_mode;

lean_obj_res lean_get_size(uint8_t u)
{
    struct winsize ws;
    ioctl(STDIN_FILENO, TIOCGWINSZ, &ws);

    lean_object *o = lean_alloc_ctor(0, 0, 2 * sizeof(uint16_t));
    lean_ctor_set_uint16(o, 0, ws.ws_col);
    lean_ctor_set_uint16(o, sizeof(uint16_t), ws.ws_row);

    return lean_io_result_mk_ok(o);
}

lean_obj_res lean_get_is_tty(uint8_t u)
{
    return lean_io_result_mk_ok(lean_box(isatty(STDOUT_FILENO)));
}

// TODO: change to the windows style
lean_obj_res lean_enable_raw_mode(uint8_t u)
{
    if (is_raw_mode == 1)
    {
        return lean_io_result_mk_ok(lean_box(0));
    }
    struct termios raw = orig_termios;
    raw.c_iflag &= ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON);
    raw.c_oflag &= ~(OPOST);
    raw.c_cflag |= (CS8);
    raw.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG);
    raw.c_cc[VMIN] = 0;
    raw.c_cc[VTIME] = 1;
    if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw) == -1)
    {
        return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("tcsetattr error")));
    }
    is_raw_mode = 1;
    return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_disable_raw_mode(uint8_t u)
{
    if (is_raw_mode == 0)
    {
        return lean_io_result_mk_ok(lean_box(0));
    }
    if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios) == -1)
    {
        return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("tcsetattr error")));
    }
    is_raw_mode = 0;
    return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_is_raw_mode_enabled(uint8_t u)
{
    return lean_io_result_mk_ok(lean_box(is_raw_mode));
}

lean_obj_res lean_initialize_terminal(uint8_t u)
{
    if (tcgetattr(STDIN_FILENO, &orig_termios) == -1)
    {
        return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("tcgetattr error during initialization")));
    }
    else
    {
        is_raw_mode = 0;
        return lean_io_result_mk_ok(lean_box(0));
    }
}

// lean_obj_res lean_get_input(uint8_t u)
// {
//     char buf[32];
//     unsigned int i = 0;
//     if (write(STDOUT_FILENO, "\x1b[6n", 4) != 4)
//     {
//         return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("write")));
//     }
//     while (i < sizeof(buf) - 1)
//     {
//         if (read(STDIN_FILENO, &buf[i], 1) != 1)
//             break;
//         if (buf[i] == 'R')
//             break;
//         i++;
//     }
//     buf[i] = '\0';

// }

#else

const DWORD NOT_RAW_MODE_MASK = ENABLE_LINE_INPUT | ENABLE_ECHO_INPUT | ENABLE_PROCESSED_INPUT;
HANDLE hStdin;

lean_obj_res lean_get_size(void)
{
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    uint16_t columns, rows;
    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);
    columns = csbi.srWindow.Right - csbi.srWindow.Left + 1;
    rows = csbi.srWindow.Bottom - csbi.srWindow.Top + 1;

    lean_object *o = lean_alloc_ctor(0, 0, 2 * sizeof(uint16_t));
    lean_ctor_set_uint16(o, 0, ws.ws_col);
    lean_ctor_set_uint16(o, sizeof(uint16_t), ws.ws_row);

    return lean_io_result_mk_ok(o);
}

lean_obj_res lean_get_is_tty(uint8_t u)
{
    if (_isatty(_fileno(stdout)))
    {
        return lean_io_result_mk_ok(lean_box(1));
    }
    else
    {
        return lean_io_result_mk_ok(lean_box(0));
    }
}

lean_obj_res lean_enable_raw_mode(uint8_t u)
{
    DWORD fdwMode;
    if (!GetConsoleMode(hStdin, &fdwMode))
    {
        return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("GetConsoleMode")));
    }
    if (!SetConsoleMode(hStdin, fdwMode & NOT_RAW_MODE_MASK))
    {
        return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("SetConsoleMode")));
    }
    return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_disable_raw_mode(uint8_t u)
{
    DWORD fdwMode;
    if (!GetConsoleMode(hStdin, &fdwMode))
    {
        return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("GetConsoleMode")));
    }
    if (!SetConsoleMode(hStdin, fdwMode & !NOT_RAW_MODE_MASK))
    {
        return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("SetConsoleMode")));
    }
    return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_is_raw_mode_enabled(uint8_t u)
{
    DWORD fdwMode;
    if (!GetConsoleMode(hStdin, &fdwMode))
    {
        return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("GetConsoleMode")));
    }
    lean_io_result_mk_ok(lean_box(fdwMode & NOT_RAW_MODE_MASK == 0));
}

lean_obj_res lean_initialize_terminal(uint8_t u)
{
    hStdin = GetStdHandle(STD_INPUT_HANDLE);
    if (hStdin == INVALID_HANDLE_VALUE)
    {
        return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string("GetStdHandle error during initialization")));
    }
    return lean_io_result_mk_ok(lean_box(0));
}
#endif
