# Synchronous FIFO — RTL Design Q&A

**Project:** Parameterized Synchronous FIFO (`rtl/fifo.sv`)  
**Scope:** Core architecture, pointers, occupancy tracking, wrap-around, reset semantics, and SystemVerilog `always_ff` behavior.

---

## Table of Contents

1. Dual Pointers: Write Pointer vs. Read Pointer
2. Pointer Ambiguity When Empty vs. Full
3. How the Occupancy Counter Resolves State Ambiguity
4. Why `COUNT_WIDTH` Can Exceed `PTR_WIDTH`
5. Non-Power-of-Two Depths and Wrap-Around
6. Simultaneous Read and Write (`wr_en` and `rd_en` Active)
7. Why Internal Memory Is Not Cleared on Reset
8. Nonblocking Assignments (`<=`) in Sequential Logic

---

## 1. Dual Pointers: Write Pointer vs. Read Pointer

**Question:** Why does a FIFO need both a Write Pointer and a Read Pointer?

### Answer
Read and write pointers are independent. The read pointer's current position represents the next element to be read out, while the write pointer indicates the next write location at the end of the active data in the buffer.  

---

## 2. Pointer Ambiguity When Empty vs. Full

**Question:** Why can both pointers point to the same address when the FIFO is both empty and full?

### Answer
Informally, the occupancy counter reflects how far ahead the write pointer has moved relative to the read pointer. 
When the FIFO is `empty`, there are 0 unread entries between them. When the FIFO is `full`, the write pointer has advanced by `FIFO_DEPTH` steps without reads, and because of wrap-around it lands back on the exact same address as the read pointer.

---

## 3. How the Occupancy Counter Resolves State Ambiguity

**Question:** How does an Occupancy Counter solve this problem?

### Answer
The occupancy counter (`count`) tracks how many unread elements are currently stored in the FIFO (0 to `FIFO_DEPTH`). Even when `write_ptr == read_ptr`, `count` unambiguously distinguishes `empty` (`count == 0`) from `full` (`count == FIFO_DEPTH`). Together with `wr_en` and `rd_en`, the resulting `full` and `empty` status flags gate whether a write or read is actually accepted on that clock cycle (`do_write` and `do_read`).

---

## 4. Why `COUNT_WIDTH` Can Exceed `PTR_WIDTH`

**Question:** Why is a larger `COUNT_WIDTH` than `PTR_WIDTH` needed in some configurations?

### Answer
`PTR_WIDTH` sets the bit width needed to address memory locations (0 to `FIFO_DEPTH` - 1), which requires ceil(log2(`FIFO_DEPTH`)) bits (with a minimum of 1 bit for very small/edge depths). `COUNT_WIDTH`, on the other hand, must represent the number of stored elements from 0 (`empty`) up to `FIFO_DEPTH` (`full`) — a total of `FIFO_DEPTH` + 1 possible states — requiring ceil(log2(`FIFO_DEPTH` + 1)) bits. In configurations like `FIFO_DEPTH` = 16 (4 bits for pointers vs. 5 bits to represent 16), `COUNT_WIDTH` is larger than `PTR_WIDTH`.

---

## 5. Non-Power-of-Two Depths and Wrap-Around

**Question:** Why can't we rely on natural binary wrap-around (overflow) when `FIFO_DEPTH` is not a power of 2?

### Answer
Because `PTR_WIDTH` is sized to address up to the next power of two ($2^{\text{PTR\_WIDTH}}$ total binary states), natural binary wrap-around only rolls over after $2^{\text{PTR\_WIDTH}}$ increments rather than at `FIFO_DEPTH`. When `FIFO_DEPTH` is not a power of two (such as 6), relying on natural binary overflow would allow `write_ptr` or `read_ptr` to step into unused indices beyond `FIFO_DEPTH` - 1 (e.g., 6 and 7), causing out-of-range memory accesses or X values in simulation. Explicit wrap-around (== `FIFO_DEPTH` - 1 back to '0) keeps pointers strictly within [0, `FIFO_DEPTH`-1].

---

## 6. Simultaneous Read and Write (`wr_en` and `rd_en` Active)

**Question:** What happens when `wr_en` and `rd_en` are both asserted (active) in the same clock cycle?

### Answer
When both `wr_en` and `rd_en` are asserted in the same clock cycle in a non-empty, non-full FIFO, both a write and a read are accepted (`do_write = 1`, `do_read = 1`). Because `always_ff` uses nonblocking assignments (<=), `mem[write_ptr]` and `write_ptr` update for the incoming data while `dout` samples the existing entry at `read_ptr` and `read_ptr` advances, leaving `count` unchanged (`{do_write, do_read} == 2'b11`). If the FIFO is empty (`!do_read`), only the write takes effect and `count` increments; if full (`!do_write`), only the read takes effect and `count` decrements.

---

## 7. Why Internal Memory Is Not Cleared on Reset

**Question:** Why don't we reset/clear the entire memory array during Reset?

### Answer
We do not need to clear the entire memory array on `reset` because validity is governed by `read_ptr`, `write_ptr`, and `count` rather than by zeroing out storage cells: only the `count` entries starting from `read_ptr` represent valid unread data, and any other entry is simply ignored and overwritten when `write_ptr` reaches it during a write. Additionally, resetting an entire memory array adds unnecessary hardware area, power, and synthesis overhead (and is often impractical for large or RAM-backed memories).

---

## 8. Nonblocking Assignments (`<=`) in Sequential Logic

**Question:** Why do we use nonblocking assignments (`<=`)?

### Answer
We use nonblocking assignments (<=) in `always_ff` @(posedge clk) to model sequential flip-flop behavior accurately: all right-hand-side expressions read the current state values at the start of the clock edge, while all updates take effect together at the end of the cycle without order-dependent race conditions or simulation-versus-synthesis mismatches.

---