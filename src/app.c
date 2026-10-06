#include <stdio.h>

#include "app.h"

const char *app_message(void)
{
    return "Hello, World!";
}

void app_run(void)
{
    printf("%s\n", app_message());
}