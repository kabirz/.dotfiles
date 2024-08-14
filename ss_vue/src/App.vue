<template>
  <div class="chat-container">
    <div class="chat-messages">
      <div v-for="(message, index) in messages" :key="index" :class="message.role">
        {{ message.content }}
      </div>
    </div>
    <div class="chat-input">
      <input v-model="userInput" @keyup.enter="sendMessage" placeholder="输入消息..." />
      <button @click="sendMessage">发送</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref} from 'vue'

let messages = ref([])
let userInput = ref('')
const API_KEY = 'sk-c40fa5dcd2a94268920931b3a1e9d566'
const API_ENDPOINT = '/api/chat/completions'

async function streamFetch() {
  const response = await fetch(API_ENDPOINT, {
    method: 'POST',
    headers: {
      Accept: 'text/event-stream',
      'Content-Type': 'application/json',
      Authorization: `Bearer ${API_KEY}`
    },
    body: JSON.stringify({
      model: 'qwen1.5-0.5b-chat',
      stream: true,
      messages: messages.value
    })
  })
  const reader = response.body.getReader()

  let msg = { role: 'assistant', content: "" }
  messages.value.push(msg)

  while (true) {
    const { done, value } = await reader.read()
    if (done) break

    // 处理接收到的数据块
    let data: string = new TextDecoder().decode(value)
    let out = data.split('\n')
    out.forEach((item) => {
      let out = item.slice(6)
      if (out.length < 10) return
      let out_json = JSON.parse(out)
      // messages.value[messages.value.length - 1].content += out_json.choices[0].delta.content
      messages.value.at(-1).content += out_json.choices[0].delta.content
    })
  }

  console.log('Stream complete')
}

function sendMessage() {
  if (userInput.value.trim() === '') return

  // 添加用户消息
  messages.value.push({ role: 'user', content: userInput.value })

  // 模拟AI响应
  streamFetch()

  // 清空输入
  userInput.value = ''
}
</script>

<style scoped>
.chat-container {
  width: 800px;
  height: 500px;
  /* margin: 0 auto; */
  padding: 20px;
}

.chat-messages {
  height: 100%;
  overflow-y: auto;
  border: 1px solid #ccc;
  padding: 10px;
  margin-bottom: 10px;
}

.user {
  text-align: right;
  color: blue;
}

.assistant {
  text-align: left;
  color: green;
}

.chat-input {
  display: flex;
}

input {
  flex-grow: 1;
  padding: 5px;
}

button {
  padding: 5px 10px;
}
</style>
