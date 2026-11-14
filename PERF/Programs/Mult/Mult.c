volatile unsigned long long multiplicand;
volatile unsigned long long multiplier;
volatile unsigned long long result;

int main(void)
{
    unsigned long long a = multiplicand;
    unsigned long long b = multiplier;
    unsigned long long product = 0;

    while (b != 0)
    {
        if (b & 1)
            product += a;

        a <<= 1;
        b >>= 1;
    }

    result = product;

    return 0;
}
