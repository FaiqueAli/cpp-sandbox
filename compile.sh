cd arithmetic_ops
make
cd ../input_handler
make
cd ../main_logic

echo 'inside script'
# cd main_logic

make
chmod 777 main_logic
./main_logic

sleep 100
