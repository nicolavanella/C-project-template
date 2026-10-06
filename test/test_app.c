#include <assert.h>
#include <string.h>

#include "app.h"

static void test_app_message(void)
{
    const char *message = app_message();

    assert(message != NULL);
    assert(strcmp(message, "Hello, World!") == 0);
}

int main(void)
{
    test_app_message();

    return 0;
}