python3 -m benchmarks.benchmark_runner on-device \
    --base_output_directory=${OUTPUT_DIR} \
    --model_name="llama3_1_8b_8192_no_collective_matmul" \
    --base_docker_image=maxtext_base_image