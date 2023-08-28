The Java code that prints the UM library statistics uses
the UM statitics classes to print human-readable text for
the statistics fields.

Here is the code, as of August 2023:

````
public class LBMContextStatistics extends LBMStatistics {
	public String displayString(String aString) {
		StringBuilder sb = new StringBuilder();
		try {
			sb.append(super.displayString(aString));
			sb.append("\n\tTopic resolution datagrams sent                    : ").append(this.topicResolutionDatagramsSent());
			sb.append("\n\tTopic resolution datagram bytes sent               : ").append(this.topicResolutionBytesSent());
			sb.append("\n\tTopic resolution datagrams received                : ").append(this.topicResolutionDatagramsReceived());
			sb.append("\n\tTopic resolution datagram bytes received           : ").append(this.topicResolutionBytesReceived());
			sb.append("\n\tTopic resolution datagrams dropped version         : ").append(this.topicResolutionDatagramsDroppedVersion());
			sb.append("\n\tTopic resolution datagrams dropped type            : ").append(this.topicResolutionDatagramsDroppedType());
			sb.append("\n\tTopic resolution datagrams dropped malformed       : ").append(this.topicResolutionDatagramsDroppedMalformed());
			sb.append("\n\tTopic resolution datagrams send failed             : ").append(this.topicResolutionDatagramsSendFailed());
			sb.append("\n\tTopic resolution source topics                     : ").append(this.topicResolutionSourceTopics());
			sb.append("\n\tTopic resolution receiver topics                   : ").append(this.topicResolutionReceiverTopics());
			sb.append("\n\tTopic resolution unresolved receiver topics        : ").append(this.topicResolutionUnresolvedReceiverTopics());
			sb.append("\n\tLBT-RM unknown datagrams received                  : ").append(this.lbtrmUnknownMessagesReceived());
			sb.append("\n\tLBT-RU unknown datagrams received                  : ").append(this.lbtruUnknownMessagesReceived());
			sb.append("\n\tLBM send calls which blocked                       : ").append(this.sendBlocked());
			sb.append("\n\tLBM send calls which returned EWOULDBLOCK          : ").append(this.sendWouldBlock());
			sb.append("\n\tLBM response calls which blocked                   : ").append(this.responseBlocked());
			sb.append("\n\tLBM response calls which returned EWOULDBLOCK      : ").append(this.responseWouldBlock());
			sb.append("\n\tNumber of duplicate UIM messages dropped           : ").append(this.unicastImmediateMessageDuplicatesReceived());
			sb.append("\n\tNumber of UIM messages received without stream info: ").append(this.unicastImmediateMessageNoStreamReceived());
			sb.append("\n\tNumber of data message fragments lost              : ").append(this.fragmentsLost());
			sb.append("\n\tNumber of data message fragments unrecoverably lost: ").append(this.fragmentsUnrecoverablyLost());
			sb.append("\n\tReceiver callbacks min service time (microseconds) : ").append(this.receiveCallbackServiceTimeMin());
			sb.append("\n\tReceiver callbacks max service time (microseconds) : ").append(this.receiveCallbackServiceTimeMax());
			sb.append("\n\tReceiver callbacks mean service time (microseconds): ").append(this.receiveCallbackServiceTimeMean());
			sb.append("\n");
		} catch (LBMException ex) {
			sb.append("\nError displaying context statistics: ").append(ex.toString());
		}
		return sb.toString();
	}
}


public class LBMEventQueueStatistics extends LBMStatistics {
	public String displayString(String aString) {
		StringBuilder sb = new StringBuilder(super.displayString(aString));
		try {
			sb.append("\n\tData messages enqueued                                        : ").append(this.dataMessages());
			sb.append("\n\tTotal data messages enqueued                                  : ").append(this.dataMessagesTotal());
			sb.append("\n\tData messages min service time (microseconds)                 : ").append(this.dataMessagesMinimumServiceTime());
			sb.append("\n\tData messages mean service time (microseconds)                : ").append(this.dataMessagesMeanServiceTime());
			sb.append("\n\tData messages max service time (microseconds)                 : ").append(this.dataMessagesMaximumServiceTime());
			sb.append("\n\tResponse messages enqueued                                    : ").append(this.responseMessages());
			sb.append("\n\tTotal response messages enqueued                              : ").append(this.responseMessagesTotal());
			sb.append("\n\tResponse messages min service time (microseconds)             : ").append(this.responseMessagesMinimumServiceTime());
			sb.append("\n\tResponse messages mean service time (microseconds)            : ").append(this.responseMessagesMeanServiceTime());
			sb.append("\n\tResponse messages max service time (microseconds)             : ").append(this.responseMessagesMaximumServiceTime());
			sb.append("\n\tTopicless immediate messages enqueued                         : ").append(this.topiclessImmediateMessages());
			sb.append("\n\tTotal topicless immediate messages enqueued                   : ").append(this.topiclessImmediateMessagesTotal());
			sb.append("\n\tTopicless immediate messages min service time (microseconds)  : ").append(this.topiclessImmediateMessagesMinimumServiceTime());
			sb.append("\n\tTopicless immediate messages mean service time (microseconds) : ").append(this.topiclessImmediateMessagesMeanServiceTime());
			sb.append("\n\tTopicless immediate messages max service time (microseconds)  : ").append(this.topiclessImmediateMessagesMaximumServiceTime());
			sb.append("\n\tWildcard receiver messages enqueued                           : ").append(this.wildcardReceiverMessages());
			sb.append("\n\tTotal wildcard receiver messages enqueued                     : ").append(this.wildcardReceiverMessagesTotal());
			sb.append("\n\tWildcard receiver messages min service time (microseconds)    : ").append(this.wildcardReceiverMessagesMinimumServiceTime());
			sb.append("\n\tWildcard receiver messages mean service time (microseconds)   : ").append(this.wildcardReceiverMessagesMeanServiceTime());
			sb.append("\n\tWildcard receiver messages max service time (microseconds)    : ").append(this.wildcardReceiverMessagesMaximumServiceTime());
			sb.append("\n\tI/O events enqueued                                           : ").append(this.ioEvents());
			sb.append("\n\tTotal I/O events enqueued                                     : ").append(this.ioEventsTotal());
			sb.append("\n\tI/O events min service time (microseconds)                    : ").append(this.ioEventsMinimumServiceTime());
			sb.append("\n\tI/O events mean service time (microseconds)                   : ").append(this.ioEventsMeanServiceTime());
			sb.append("\n\tI/O events max service time (microseconds)                    : ").append(this.ioEventsMaximumServiceTime());
			sb.append("\n\tTimer events enqueued                                         : ").append(this.timerEvents());
			sb.append("\n\tTotal timer events enqueued                                   : ").append(this.timerEventsTotal());
			sb.append("\n\tTimer events min service time (microseconds)                  : ").append(this.timerEventsMinimumServiceTime());
			sb.append("\n\tTimer events mean service time (microseconds)                 : ").append(this.timerEventsMeanServiceTime());
			sb.append("\n\tTimer events max service time (microseconds)                  : ").append(this.timerEventsMaximumServiceTime());
			sb.append("\n\tSource events enqueued                                        : ").append(this.sourceEvents());
			sb.append("\n\tTotal source events enqueued                                  : ").append(this.sourceEventsTotal());
			sb.append("\n\tSource events min service time (microseconds)                 : ").append(this.sourceEventsMinimumServiceTime());
			sb.append("\n\tSource events mean service time (microseconds)                : ").append(this.sourceEventsMeanServiceTime());
			sb.append("\n\tSource events max service time (microseconds)                 : ").append(this.sourceEventsMaximumServiceTime());
			sb.append("\n\tUnblock events enqueued                                       : ").append(this.unblockEvents());
			sb.append("\n\tTotal unblock events enqueued                                 : ").append(this.unblockEventsTotal());
			sb.append("\n\tCancel events enqueued                                        : ").append(this.cancelEvents());
			sb.append("\n\tTotal cancel events enqueued                                  : ").append(this.cancelEventsTotal());
			sb.append("\n\tCancel events min service time (microseconds)                 : ").append(this.cancelEventsMinimumServiceTime());
			sb.append("\n\tCancel events mean service time (microseconds)                : ").append(this.cancelEventsMeanServiceTime());
			sb.append("\n\tCancel events max service time (microseconds)                 : ").append(this.cancelEventsMaximumServiceTime());
			sb.append("\n\tCallback events enqueued                                      : ").append(this.callbackEvents());
			sb.append("\n\tTotal callback events enqueued                                : ").append(this.callbackEventsTotal());
			sb.append("\n\tCallback events min service time (microseconds)               : ").append(this.callbackEventsMinimumServiceTime());
			sb.append("\n\tCallback events mean service time (microseconds)              : ").append(this.callbackEventsMeanServiceTime());
			sb.append("\n\tCallback events max service time (microseconds)               : ").append(this.callbackEventsMaximumServiceTime());
			sb.append("\n\tContext source events enqueued                                : ").append(this.contextSourceEvents());
			sb.append("\n\tTotal context source events enqueued                          : ").append(this.contextSourceEventsTotal());
			sb.append("\n\tContext source events min service time (microseconds)         : ").append(this.contextSourceEventsMinimumServiceTime());
			sb.append("\n\tContext source events mean service time (microseconds)        : ").append(this.contextSourceEventsMeanServiceTime());
			sb.append("\n\tContext source events max service time (microseconds)         : ").append(this.contextSourceEventsMaximumServiceTime());
			sb.append("\n\tEvents currently enqueued                                     : ").append(this.events());
			sb.append("\n\tTotal events enqueued                                         : ").append(this.eventsTotal());
			sb.append("\n\tMinimum age of events enqueued (microseconds)                 : ").append(this.minimumAge());
			sb.append("\n\tMean age of events enqueued (microseconds)                    : ").append(this.meanAge());
			sb.append("\n\tMax age of events enqueued (microseconds)                     : ").append(this.maximumAge());
			sb.append("\n");
		} catch (Exception ex) {
			sb.append("\nError displaying event queue statistics: " + ex.toString());
		}
		return sb.toString();
	}
}


public class LBMImmediateMessageReceiverStatistics extends LBMStatistics {
	public String displayString(String aString) {
		StringBuilder sb = new StringBuilder(super.displayString(aString));
		try {
			sb.append("\nSource: ").append(this.source());
			sb.append("\nTransport: ").append(this.typeName());
			switch (this.type())
			{
				case LBM.TRANSPORT_STAT_TCP:
					sb.append("\n\tLBT-TCP bytes received                                    : ").append(this.bytesReceived());
					sb.append("\n\tLBM messages received                                     : ").append(this.lbmMessagesReceived());
					sb.append("\n\tLBM messages received with uninteresting topic            : ").append(this.noTopicMessagesReceived());
					sb.append("\n\tLBM requests received                                     : ").append(this.lbmRequestsReceived());
					break;
				case LBM.TRANSPORT_STAT_LBTRM:
					sb.append("\n\tLBT-RM datagrams received                                 : ").append(this.messagesReceived());
					sb.append("\n\tLBT-RM datagram bytes received                            : ").append(this.bytesReceived());
					sb.append("\n\tLBT-RM NAK packets sent                                   : ").append(this.nakPacketsSent());
					sb.append("\n\tLBT-RM NAKs sent                                          : ").append(this.naksSent());
					sb.append("\n\tLost LBT-RM datagrams detected                            : ").append(this.lost());
					sb.append("\n\tNCFs received (ignored)                                   : ").append(this.ncfsIgnored());
					sb.append("\n\tNCFs received (shed)                                      : ").append(this.ncfsShed());
					sb.append("\n\tNCFs received (retransmit delay)                          : ").append(this.ncfsRetransmissionDelay());
					sb.append("\n\tNCFs received (unknown)                                   : ").append(this.ncfsUnknown());
					sb.append("\n\tLoss recovery minimum time                                : ").append(this.minimumRecoveryTime() + "ms");
					sb.append("\n\tLoss recovery mean time                                   : ").append(this.meanRecoveryTime() + "ms");
					sb.append("\n\tLoss recovery maximum time                                : ").append(this.maximumRecoveryTime() + "ms");
					sb.append("\n\tMinimum transmissions per individual NAK                  : ").append(this.minimumNakTransmissions());
					sb.append("\n\tMean transmissions per individual NAK                     : ").append(this.meanNakTransmissions());
					sb.append("\n\tMaximum transmissions per individual NAK                  : ").append(this.maximumNakTransmissions());
					sb.append("\n\tDuplicate LBT-RM datagrams received                       : ").append(this.duplicateMessages());
					sb.append("\n\tLBT-RM datagrams unrecoverable (window advance)           : ").append(this.unrecoveredMessagesWindowAdvance());
					sb.append("\n\tLBT-RM datagrams unrecoverable (NAK generation expiration): ").append(this.unrecoveredMessagesNakGenerationTimeout());
					sb.append("\n\tLBT-RM LBM messages received                              : ").append(this.lbmMessagesReceived());
					sb.append("\n\tLBT-RM LBM messages received with uninteresting topic     : ").append(this.noTopicMessagesReceived());
					sb.append("\n\tLBT-RM LBM requests received                              : ").append(this.lbmRequestsReceived());
					sb.append("\n\tLBT-RM datagrams dropped (size)                           : ").append(this.datagramsDroppedIncorrectSize());
					sb.append("\n\tLBT-RM datagrams dropped (type)                           : ").append(this.datagramsDroppedType());
					sb.append("\n\tLBT-RM datagrams dropped (version)                        : ").append(this.datagramsDroppedVersion());
					sb.append("\n\tLBT-RM datagrams dropped (header)                         : ").append(this.datagramsDroppedHeader());
					sb.append("\n\tLBT-RM datagrams dropped (other)                          : ").append(this.datagramsDroppedOther());
					sb.append("\n\tLBT-RM datagrams received out of order                    : ").append(this.outOfOrder());
					break;
				default:
					sb.append("\nError: unknown transport type received.").append(this.type());
					break;
			}
			sb.append("\n");
		} catch (Exception ex) {
			sb.append("\nError displaying immediate message receiver statistics: ").append(ex.toString());
		}
		return sb.toString();
	}
}


public class LBMImmediateMessageSourceStatistics extends LBMStatistics {
	public String displayString(String aString) {
		StringBuilder sb = new StringBuilder(super.displayString(aString));
		try {
			sb.append("\nSource: ").append(this.source());
			sb.append("\nTransport: ").append(this.typeName());
			switch (this.type()) {
				case LBM.TRANSPORT_STAT_TCP:
					sb.append("\n\tClients       : ").append(this.numberOfClients());
					sb.append("\n\tBytes buffered: ").append(this.bytesBuffered());
					break;
				case LBM.TRANSPORT_STAT_LBTRM:
					sb.append("\n\tLBT-RM datagrams sent                                 : ").append(this.messagesSent());
					sb.append("\n\tLBT-RM datagrams bytes sent                           : ").append(this.bytesSent());
					sb.append("\n\tLBT-RM datagrams in transmission window               : ").append(this.transmissionWindowMessages());
					sb.append("\n\tLBT-RM datagram bytes in transmission window          : ").append(this.transmissionWindowBytes());
					sb.append("\n\tLBT-RM NAK packets received                           : ").append(this.nakPacketsReceived());
					sb.append("\n\tLBT-RM NAKs received                                  : ").append(this.naksReceived());
					sb.append("\n\tLBT-RM NAKs ignored                                   : ").append(this.naksIgnored());
					sb.append("\n\tLBT-RM NAKs shed                                      : ").append(this.naksShed());
					sb.append("\n\tLBT-RM NAKs ignored (retransmit delay)                : ").append(this.naksIgnoredRetransmitDelay());
					sb.append("\n\tLBT-RM retransmission datagrams sent                  : ").append(this.retransmissionsSent());
					sb.append("\n\tLBT-RM retransmission datagram bytes sent             : ").append(this.retransmissionBytesSent());
					sb.append("\n\tLBT-RM datagrams queued by rate control               : ").append(this.messagesQueued());
					sb.append("\n\tLBT-RM retransmission datagrams queued by rate control: ").append(this.retransmissionsQueued());
					break;
				default:
					sb.append("\nError: unknown transport type received.").append(this.type());
					break;
			}
			sb.append("\n");
		} catch (Exception ex) {
			sb.append("\nError displaying immediate message source statistics: ").append(ex.toString());
		}
		return sb.toString();
	}
}


public class LBMReceiverStatistics extends LBMStatistics {
	public String displayString(String aString) {
		StringBuilder sb = new StringBuilder();
		try {
			sb.append(super.displayString(aString));
			sb.append("\nSource: ").append(this.source());
			sb.append("\nTransport: ").append(this.typeName());
			switch (this.type()) {
				case LBM.TRANSPORT_STAT_TCP:
					sb.append("\n\tLBT-TCP bytes received                                    : ").append(this.bytesReceived());
					sb.append("\n\tLBM messages received                                     : ").append(this.lbmMessagesReceived());
					sb.append("\n\tLBM messages received with uninteresting topic            : ").append(this.noTopicMessagesReceived());
					sb.append("\n\tLBM requests received                                     : ").append(this.lbmRequestsReceived());
					break;
				case LBM.TRANSPORT_STAT_LBTRM:
					sb.append("\n\tLBT-RM datagrams received                                 : ").append(this.messagesReceived());
					sb.append("\n\tLBT-RM datagram bytes received                            : ").append(this.bytesReceived());
					sb.append("\n\tLBT-RM NAK packets sent                                   : ").append(this.nakPacketsSent());
					sb.append("\n\tLBT-RM NAKs sent                                          : ").append(this.naksSent());
					sb.append("\n\tLost LBT-RM datagrams detected                            : ").append(this.lost());
					sb.append("\n\tNCFs received (ignored)                                   : ").append(this.ncfsIgnored());
					sb.append("\n\tNCFs received (shed)                                      : ").append(this.ncfsShed());
					sb.append("\n\tNCFs received (retransmit delay)                          : ").append(this.ncfsRetransmissionDelay());
					sb.append("\n\tNCFs received (unknown)                                   : ").append(this.ncfsUnknown());
					sb.append("\n\tLoss recovery minimum time                                : ").append(this.minimumRecoveryTime() + "ms");
					sb.append("\n\tLoss recovery mean time                                   : ").append(this.meanRecoveryTime() + "ms");
					sb.append("\n\tLoss recovery maximum time                                : ").append(this.maximumRecoveryTime() + "ms");
					sb.append("\n\tMinimum transmissions per individual NAK                  : ").append(this.minimumNakTransmissions());
					sb.append("\n\tMean transmissions per individual NAK                     : ").append(this.meanNakTransmissions());
					sb.append("\n\tMaximum transmissions per individual NAK                  : ").append(this.maximumNakTransmissions());
					sb.append("\n\tDuplicate LBT-RM datagrams received                       : ").append(this.duplicateMessages());
					sb.append("\n\tLBT-RM datagrams unrecoverable (window advance)           : ").append(this.unrecoveredMessagesWindowAdvance());
					sb.append("\n\tLBT-RM datagrams unrecoverable (NAK generation expiration): ").append(this.unrecoveredMessagesNakGenerationTimeout());
					sb.append("\n\tLBT-RM LBM messages received                              : ").append(this.lbmMessagesReceived());
					sb.append("\n\tLBT-RM LBM messages received with uninteresting topic     : ").append(this.noTopicMessagesReceived());
					sb.append("\n\tLBT-RM LBM requests received                              : ").append(this.lbmRequestsReceived());
					sb.append("\n\tLBT-RM datagrams dropped (size)                           : ").append(this.datagramsDroppedIncorrectSize());
					sb.append("\n\tLBT-RM datagrams dropped (type)                           : ").append(this.datagramsDroppedType());
					sb.append("\n\tLBT-RM datagrams dropped (version)                        : ").append(this.datagramsDroppedVersion());
					sb.append("\n\tLBT-RM datagrams dropped (header)                         : ").append(this.datagramsDroppedHeader());
					sb.append("\n\tLBT-RM datagrams dropped (other)                          : ").append(this.datagramsDroppedOther());
					sb.append("\n\tLBT-RM datagrams received out of order                    : ").append(this.outOfOrder());
					break;
				case LBM.TRANSPORT_STAT_LBTRU:
					sb.append("\n\tLBT-RU datagrams received                                 : ").append(this.messagesReceived());
					sb.append("\n\tLBT-RU datagram bytes received                            : ").append(this.bytesReceived());
					sb.append("\n\tLBT-RU NAK packets sent                                   : ").append(this.nakPacketsSent());
					sb.append("\n\tLBT-RU NAKs sent                                          : ").append(this.naksSent());
					sb.append("\n\tLost LBT-RU datagrams detected                            : ").append(this.lost());
					sb.append("\n\tNCFs received (ignored)                                   : ").append(this.ncfsIgnored());
					sb.append("\n\tNCFs received (shed)                                      : ").append(this.ncfsShed());
					sb.append("\n\tNCFs received (retransmit delay)                          : ").append(this.ncfsRetransmissionDelay());
					sb.append("\n\tNCFs received (unknown)                                   : ").append(this.ncfsUnknown());
					sb.append("\n\tLoss recovery minimum time                                : ").append(this.minimumRecoveryTime() + "ms");
					sb.append("\n\tLoss recovery mean time                                   : ").append(this.meanRecoveryTime() + "ms");
					sb.append("\n\tLoss recovery maximum time                                : ").append(this.maximumRecoveryTime() + "ms");
					sb.append("\n\tMinimum transmissions per individual NAK                  : ").append(this.minimumNakTransmissions());
					sb.append("\n\tMean transmissions per individual NAK                     : ").append(this.meanNakTransmissions());
					sb.append("\n\tMaximum transmissions per individual NAK                  : ").append(this.maximumNakTransmissions());
					sb.append("\n\tDuplicate LBT-RU datagrams received                       : ").append(this.duplicateMessages());
					sb.append("\n\tLBT-RU datagrams unrecoverable (window advance)           : ").append(this.unrecoveredMessagesWindowAdvance());
					sb.append("\n\tLBT-RU datagrams unrecoverable (NAK generation expiration): ").append(this.unrecoveredMessagesNakGenerationTimeout());
					sb.append("\n\tLBT-RU LBM messages received                              : ").append(this.lbmMessagesReceived());
					sb.append("\n\tLBT-RU LBM messages received with uninteresting topic     : ").append(this.noTopicMessagesReceived());
					sb.append("\n\tLBT-RU LBM requests received                              : ").append(this.lbmRequestsReceived());
					sb.append("\n\tLBT-RU datagrams dropped (size)                           : ").append(this.datagramsDroppedIncorrectSize());
					sb.append("\n\tLBT-RU datagrams dropped (type)                           : ").append(this.datagramsDroppedType());
					sb.append("\n\tLBT-RU datagrams dropped (version)                        : ").append(this.datagramsDroppedVersion());
					sb.append("\n\tLBT-RU datagrams dropped (header)                         : ").append(this.datagramsDroppedHeader());
					sb.append("\n\tLBT-RU datagrams dropped (SID)                            : ").append(this.datagramsDroppedSID());
					sb.append("\n\tLBT-RU datagrams dropped (other)                          : ").append(this.datagramsDroppedOther());
					break;
				case LBM.TRANSPORT_STAT_LBTIPC:
					sb.append("\n\tLBT-IPC datagrams received                                :").append(this.messagesReceived());
					sb.append("\n\tLBT-IPC datagram bytes received                           :").append(this.bytesReceived());
					sb.append("\n\tLBT-IPC LBM messages received                             :").append(this.lbmMessagesReceived());
					sb.append("\n\tLBT-IPC LBM messages received with uninteresting topic    :").append(this.noTopicMessagesReceived());
					sb.append("\n\tLBT-IPC LBM requests received                             :").append(this.lbmRequestsReceived());
					break;
				case LBM.TRANSPORT_STAT_LBTSMX:
					sb.append("\n\tLBT-SMX datagrams received                                :").append(this.messagesReceived());
					sb.append("\n\tLBT-SMX datagram bytes received                           :").append(this.bytesReceived());
					sb.append("\n\tLBT-SMX LBM messages received                             :").append(this.lbmMessagesReceived());
					sb.append("\n\tLBT-SMX LBM messages received with uninteresting topic    :").append(this.noTopicMessagesReceived());
					sb.append("\n\tLBT-SMX LBM requests received                             :").append(this.lbmRequestsReceived());
					break;
				case LBM.TRANSPORT_STAT_LBTRDMA:
					sb.append("\n\tLBT-RDMA datagrams received                                :").append(this.messagesReceived());
					sb.append("\n\tLBT-RDMA datagram bytes received                           :").append(this.bytesReceived());
					sb.append("\n\tLBT-RDMA LBM messages received                             :").append(this.lbmMessagesReceived());
					sb.append("\n\tLBT-RDMA LBM messages received with uninteresting topic    :").append(this.noTopicMessagesReceived());
					sb.append("\n\tLBT-RDMA LBM requests received                             :").append(this.lbmRequestsReceived());
					break;
				case LBM.TRANSPORT_STAT_BROKER:
					sb.append("\n\tBROKER messages received                                   : ").append(this.messagesReceived());
					sb.append("\n\tBROKER message bytes received                              : ").append(this.bytesReceived());
					break;
				default:
					sb.append("\nError: unknown transport type received.").append(this.type());
					break;
			}
			sb.append("\n");
		} catch (LBMException ex) {
			sb.append("\nError displaying receiver transport statistics: ").append(ex.toString());
		}
		return sb.toString();
	}
}


public class LBMSourceStatistics extends LBMStatistics {
	public String displayString(String aString) {
		StringBuilder sb = new StringBuilder(super.displayString(aString));
		try {
			sb.append("\nSource: ").append(this.source());
			sb.append("\nTransport: ").append(this.typeName());
			switch (this.type()) {
				case LBM.TRANSPORT_STAT_TCP:
					sb.append("\n\tClients       : ").append(this.numberOfClients());
					sb.append("\n\tBytes buffered: ").append(this.bytesBuffered());
					break;
				case LBM.TRANSPORT_STAT_LBTRM:
					sb.append("\n\tLBT-RM datagrams sent                                 : ").append(this.messagesSent());
					sb.append("\n\tLBT-RM datagram bytes sent                            : ").append(this.bytesSent());
					sb.append("\n\tLBT-RM datagrams in transmission window               : ").append(this.transmissionWindowMessages());
					sb.append("\n\tLBT-RM datagram bytes in transmission window          : ").append(this.transmissionWindowBytes());
					sb.append("\n\tLBT-RM NAK packets received                           : ").append(this.nakPacketsReceived());
					sb.append("\n\tLBT-RM NAKs received                                  : ").append(this.naksReceived());
					sb.append("\n\tLBT-RM NAKs ignored                                   : ").append(this.naksIgnored());
					sb.append("\n\tLBT-RM NAKs shed                                      : ").append(this.naksShed());
					sb.append("\n\tLBT-RM NAKs ignored (retransmit delay)                : ").append(this.naksIgnoredRetransmitDelay());
					sb.append("\n\tLBT-RM retransmission datagrams sent                  : ").append(this.retransmissionsSent());
					sb.append("\n\tLBT-RM retransmission datagrams bytes sent            : ").append(this.retransmissionBytesSent());
					sb.append("\n\tLBT-RM datagrams queued by rate control               : ").append(this.messagesQueued());
					sb.append("\n\tLBT-RM retransmission datagrams queued by rate control: ").append(this.retransmissionsQueued());
					break;
				case LBM.TRANSPORT_STAT_LBTRU:
					sb.append("\n\tLBT-RU datagrams sent                    : ").append(this.messagesSent());
					sb.append("\n\tLBT-RU datagram bytes sent               : ").append(this.bytesSent());
					sb.append("\n\tLBT-RU NAK packets received              : ").append(this.nakPacketsReceived());
					sb.append("\n\tLBT-RU NAKs received                     : ").append(this.naksReceived());
					sb.append("\n\tLBT-RU NAKs ignored                      : ").append(this.naksIgnored());
					sb.append("\n\tLBT-RU NAKs shed                         : ").append(this.naksShed());
					sb.append("\n\tLBT-RU NAKs ignored (retransmit delay)   : ").append(this.naksIgnoredRetransmitDelay());
					sb.append("\n\tLBT-RU retransmission datagrams sent     : ").append(this.retransmissionsSent());
					sb.append("\n\tLBT-RU retransmission datagram bytes sent: ").append(this.retransmissionBytesSent());
					sb.append("\n\tClients                                  : ").append(this.numberOfClients());
					break;
				case LBM.TRANSPORT_STAT_LBTIPC:
					sb.append("\n\tClients                    :").append(this.numberOfClients());
					sb.append("\n\tLBT-IPC datagrams sent     :").append(this.messagesSent());
					sb.append("\n\tLBT-IPC datagram bytes sent:").append(this.bytesSent());
					break;
				case LBM.TRANSPORT_STAT_LBTSMX:
					sb.append("\n\tClients                    :").append(this.numberOfClients());
					sb.append("\n\tLBT-SMX datagrams sent     :").append(this.messagesSent());
					sb.append("\n\tLBT-SMX datagram bytes sent:").append(this.bytesSent());
					break;
				case LBM.TRANSPORT_STAT_LBTRDMA:
					sb.append("\n\tClients                    :").append(this.numberOfClients());
					sb.append("\n\tLBT-RDMA datagrams sent     :").append(this.messagesSent());
					sb.append("\n\tLBT-RDMA datagram bytes sent:").append(this.bytesSent());
					break;
				case LBM.TRANSPORT_STAT_BROKER:
					sb.append("\n\tBROKER messages sent       : ").append(this.messagesSent());
					sb.append("\n\tBROKER message bytes sent  : ").append(this.bytesSent());
					break;
				default:
					sb.append("\nError: unknown transport type received.").append(this.type());
					break;
			}
			sb.append("\n");
		} catch (Exception ex) {
			sb.append("\nError displaying source statistics: ").append(ex.toString());
		}
		return sb.toString();
	}
}


public class LBMStatistics {
	public String displayString(String aString) {
		StringBuilder sb = new StringBuilder();
		try {
			sb.append(aString);
			sb.append(" from ").append(this.getApplicationSourceId());
			sb.append(" at ").append(this.getSender().getHostAddress());
			if (_processid != 0) {
				sb.append(", process ID=").append(Long.toHexString(this.getProcessId()));
			}
			if (_contextid != 0) {
				sb.append(", object ID=").append(Long.toHexString(this.getContextId()));
			}
			if ((_contextinstance != null) && (!_contextinstance.isEmpty())) {
				sb.append(", context instance=").append(this.getContextInstance());
			}
			sb.append(", domain ID=").append(this.getDomainId());
			sb.append(", sent ").append(this.getTimestamp());
		} catch (Exception ex) {
			sb.append("\nError displaying statistics: ").append(ex.toString());
		}
		return sb.toString();
	}
}
````
