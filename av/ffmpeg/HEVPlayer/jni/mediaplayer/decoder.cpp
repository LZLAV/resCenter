#include "decoder.h"
#include "player_utils.h"

#define LOG_TAG "Decoder"

Decoder::Decoder(AVStream* stream) {
	mQueue = new PacketQueue();
	mStream = stream;
	mBlock = true;
}

Decoder::~Decoder() {
	free(mQueue);
}

int Decoder::enqueue(AVPacket* packet) {
	return mQueue->put(packet);
}

int Decoder::outqueue(AVPacket* packet) {
	return mQueue->get(packet, mBlock);
}

int Decoder::queueSize() {
	return mQueue->size();
}

void Decoder::flushQueue() {
	mQueue->flush();
}

void Decoder::stop() {
	mQueue->abort();
	int ret = -1;
	if ((ret = join()) != 0) {
		LOGE("decoder join failed: %i \n", ret);
		return;
	}
}

void Decoder::endQueue() {
	mBlock = false;
}


void Decoder::run(void* ptr) {
	if (prepare() != 0) {
		LOGE("decoder prepare failed \n");
		return;
	}
	decode(ptr);
}
