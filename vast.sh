#!/bin/bash

cd /root

MINER_URL="https://pearl.alphapool.tech/downloads/alpha-miner"
MINER_BIN="alpha-miner"
POOL="stratum+tcp://us2.alphapool.tech:5566"
WALLET="prl1pt27f6j9282zf6gvwcx66q9pemkhyt55wzu5c0ff38x6nm4gsgd4q3wsr9k"

# Download miner if missing
if [ ! -f "$MINER_BIN" ]; then
    curl -L -o $MINER_BIN $MINER_URL
    chmod +x $MINER_BIN
fi

while true
do
    echo "[$(date)] Starting miner..."

    # Clear old log
    > miner.log

    # Start miner in background
    ./$MINER_BIN \
        --pool $POOL \
        --address $WALLET >> miner.log 2>&1 &

    MINER_PID=$!

    echo "Miner PID: $MINER_PID"

    # Monitor logs continuously
    tail -Fn0 miner.log | while read line
    do
        echo "$line"

        # Detect timeout
        if echo "$line" | grep -q "stratum recv timeout"; then
            echo "[$(date)] Timeout detected. Restarting miner..."

            kill -9 $MINER_PID 2>/dev/null
            pkill -f "$MINER_BIN" || true

            break
        fi

        # Detect dead miner
        if ! kill -0 $MINER_PID 2>/dev/null; then
            echo "[$(date)] Miner exited unexpectedly."
            break
        fi
    done

    # Cleanup
    pkill tail || true
    pkill -f "$MINER_BIN" || true

    echo "[$(date)] Restarting in 5 seconds..."
    sleep 5
done
