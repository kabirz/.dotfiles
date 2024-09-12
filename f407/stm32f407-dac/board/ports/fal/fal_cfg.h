/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2018-12-5      SummerGift   first version
 */

#ifndef _FAL_CFG_H_
#define _FAL_CFG_H_

#include <board.h>
#include <fal_def.h>

#define FS_START    (0)
#define FS_SIZE     (10 * 1024 * 1024)
#define RS_START    (FS_START + FS_SIZE)
#define RS_SIZE     (6 * 1024 * 1024)

extern struct fal_flash_dev w25q128;
/* flash device table */
#define FAL_FLASH_DEV_TABLE                                          \
{                                                                    \
    &w25q128,                                                        \
}

/* ====================== Partition Configuration ========================== */

#define FAL_PART_TABLE                                                    \
{                                                                         \
    {FAL_PART_MAGIC_WROD, "filesystem", "W25Q128", FS_START, FS_SIZE, 0}, \
    {FAL_PART_MAGIC_WROD, "resource",   "W25Q128", RS_START, RS_SIZE, 0}, \
}
#endif /*FAL_PART_TABLE*/

