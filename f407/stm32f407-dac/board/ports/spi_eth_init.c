#include <rtthread.h>
#include <drv_gpio.h>
#include <drv_spi.h>


#if defined(BSP_USING_SPI_W5500)
static int rt_hw_spi_w5500_init(void)
{
    rt_err_t  ret = RT_ERROR;

    __HAL_RCC_GPIOB_CLK_ENABLE();
    ret = rt_hw_spi_device_attach("spi2", "spi20", GET_PIN(B, 12));
    if (ret != RT_EOK) {
        rt_kprintf("w5500 attach spi2 failed\n");
        return ret;
    }

    return RT_EOK;
}
INIT_COMPONENT_EXPORT(rt_hw_spi_w5500_init);
#endif

