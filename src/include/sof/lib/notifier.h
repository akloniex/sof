/* SPDX-License-Identifier: BSD-3-Clause
 *
 * Copyright(c) 2016 Intel Corporation. All rights reserved.
 *
 * Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
 */

#ifndef __SOF_LIB_NOTIFIER_H__
#define __SOF_LIB_NOTIFIER_H__

#include <sof/list.h>
#include <sof/spinlock.h>
#include <stdint.h>

struct sof;

/* notifier target core masks */
#define NOTIFIER_TARGET_CORE_MASK(x)	(1 << x)
#define NOTIFIER_TARGET_CORE_LOCAL	NOTIFIER_TARGET_CORE_MASK(cpu_get_id())
#define NOTIFIER_TARGET_CORE_ALL_MASK	0xFFFFFFFF

enum notify_id {
	NOTIFIER_ID_CPU_FREQ = 0,		/* struct clock_notify_data * */
	NOTIFIER_ID_SSP_FREQ,			/* struct clock_notify_data * */
	NOTIFIER_ID_KPB_CLIENT_EVT,		/* struct kpb_event_data * */
	NOTIFIER_ID_DMA_DOMAIN_CHANGE,		/* struct dma_chan_data * */
	NOTIFIER_ID_BUFFER_PRODUCE,		/* struct buffer_cb_transact* */
	NOTIFIER_ID_BUFFER_CONSUME,		/* struct buffer_cb_transact* */
	NOTIFIER_ID_BUFFER_FREE,		/* struct buffer_cb_free* */
	NOTIFIER_ID_DMA_COPY,			/* struct dma_cb_data* */
	NOTIFIER_ID_DMA_IRQ,			/* struct dma_chan_data * */
	NOTIFIER_ID_ALL,
	NOTIFIER_ID_MAX = NOTIFIER_ID_ALL
};

struct notify {
	spinlock_t *lock;	/* notifier lock */
	struct list_item list[NOTIFIER_ID_MAX];	/* list of callback handles */
};

#define NOTIFIER_CLK_CHANGE_ID(clk) \
	((clk) == CLK_SSP ? NOTIFIER_ID_SSP_FREQ : NOTIFIER_ID_CPU_FREQ)

struct notify **arch_notify_get(void);

int notifier_register(void *receiver, void *caller, enum notify_id type,
		void (*cb)(void *arg, enum notify_id type, void *data));
void notifier_unregister(void *receiver, void *caller, enum notify_id type);
void notifier_unregister_all(void *receiver, void *caller);

void notifier_notify_remote(void);
void notifier_event(void *caller, enum notify_id type, uint32_t core_mask,
		    void *data, uint32_t data_size);

void init_system_notify(struct sof *sof);

void free_system_notify(void);

#endif /* __SOF_LIB_NOTIFIER_H__ */
