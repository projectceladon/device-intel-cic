/*
 * Copyright (C) 2017 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "netlinkmessage.h"

#include "log.h"

#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <sys/types.h>
#include <unistd.h>

size_t getSpaceForMessageType(uint16_t type) {
    switch (type) {
        case RTM_NEWLINK:
        case RTM_GETLINK:
            return NLMSG_SPACE(sizeof(ifinfomsg));
        default:
            return 0;
    }
}

NetlinkMessage::NetlinkMessage(uint16_t type,
                               uint32_t sequence)
    : mData(getSpaceForMessageType(type), 0) {

    auto header = reinterpret_cast<nlmsghdr*>(mData.data());
    header->nlmsg_len = mData.size();
    header->nlmsg_flags = NLM_F_REQUEST;
    header->nlmsg_type = type;
    header->nlmsg_seq = sequence;
    header->nlmsg_pid = getpid();
}

NetlinkMessage::NetlinkMessage(const char* data, size_t size)
    : mData(data, data + size) {
}

bool NetlinkMessage::getAttribute(int attributeId, void* data, size_t size) const {
    const void* value = nullptr;
    uint16_t attrSize = 0;
    if (!findAttribute(attributeId, &value, &attrSize)) {
        return false;
    }
    if (size > attrSize) {
        return false;
    }
    memcpy(data, value, size);
    return true;
}

uint16_t NetlinkMessage::type() const {
    auto header = reinterpret_cast<const nlmsghdr*>(mData.data());
    return header->nlmsg_type;
}

uint32_t NetlinkMessage::sequence() const {
    auto header = reinterpret_cast<const nlmsghdr*>(mData.data());
    return header->nlmsg_seq;
}

bool NetlinkMessage::findAttribute(int attributeId,
                                   const void** value,
                                   uint16_t* size) const {
    const uint8_t* end = mData.data() + mData.size();
    size_t attrOffset = getSpaceForMessageType(type());
    if (attrOffset == 0) {
        return false;
    }
    const uint8_t* attribute = mData.data() + attrOffset;
    while (attribute < end) {
        auto header = reinterpret_cast<const nlattr*>(attribute);
        if (header->nla_len == 0) {
            // The length should include the header so the length should always
            // be greater than zero. If it doesn't we're going to end up looping
            // forever so ignore this.
            return false;
        }
        if (header->nla_type == attributeId) {
            *value = attribute + NLA_HDRLEN;
            *size = header->nla_len;
            return true;
        }
        attribute += header->nla_len;
    }
    return false;
}
