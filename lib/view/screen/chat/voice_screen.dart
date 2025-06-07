import 'package:dr_ai/utils/helper/extention.dart';
import 'package:dr_ai/utils/helper/scaffold_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:dr_ai/logic/chat/chat_cubit.dart';
import 'package:dr_ai/utils/constant/color.dart';

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  bool _isProcessing = false;
  bool _isSpeaking = false;
  String _transcribedText = 'Tap on the microphone to start';
  String _responseText = '';
  String _selectedLanguage = 'en-US';
  bool _isArabic = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
  }

  Future<void> _initSpeech() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      customSnackBar(context, 'Failed to initialize speech recognition');
    }
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage(_getTextToSpeechLanguage());
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  String _getTextToSpeechLanguage() {
    return _isArabic ? 'ar-EG' : 'en-US';
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _transcribedText = 'Listening...';
        });
        _speechToText.listen(
          localeId: _selectedLanguage,
          onResult: (result) {
            setState(() {
              _transcribedText = result.recognizedWords.isNotEmpty
                  ? result.recognizedWords
                  : 'Listening...';
              if (result.finalResult) {
                _isListening = false;
                _isProcessing = true;
              }
            });
            if (result.finalResult &&
                _transcribedText.isNotEmpty &&
                _transcribedText != 'Listening...') {
              _processQuery(_transcribedText);
            }
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _transcribedText = 'Tap on the microphone to start';
      });
      _speechToText.stop();
    }
  }

  Future<void> _processQuery(String query) async {
    try {
      setState(() {
        _isProcessing = true;
      });
      // Send message and wait for response
      await context
          .read<ChatCubit>()
          .sendMessageAndWaitForResponse(message: query);
    } catch (e) {
      setState(() {
        _transcribedText = 'Error: $e';
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.setLanguage(_getTextToSpeechLanguage());
      setState(() {
        _isSpeaking = true;
      });
      await _flutterTts.speak(text);
    }
  }

  Future<void> _stopSpeaking() async {
    setState(() {
      _isSpeaking = false;
    });
    await _flutterTts.stop();
  }

  void _toggleLanguage() {
    setState(() {
      _isArabic = !_isArabic;
      _selectedLanguage = _isArabic ? 'ar-EG' : 'en-US';
      _transcribedText = 'Tap on the microphone to start';
    });
    _initTts();
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Chat"),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: _toggleLanguage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: ColorManager.green.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language),
                      const SizedBox(width: 4),
                      Text(
                        _isArabic ? "AR" : "EN",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatReceiveSuccess) {
            final messages = state.response;
            if (messages.isNotEmpty && !messages[0].isUser) {
              setState(() {
                _responseText = messages[0].message;
                _isProcessing = false;
              });
              _speak(_responseText);
            }
          }
          if (state is ChatFailure) {
            setState(() {
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: ColorManager.green,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Question:',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _transcribedText,
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: ColorManager.black),
                          textAlign:
                              _isArabic ? TextAlign.right : TextAlign.left,
                          textDirection:
                              _isArabic ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildResponseSection(state),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50.h),
        child: AvatarGlow(
          glowRadiusFactor: !_isListening ? 0.6 : 1.3,
          glowCount: !_isListening ? 4 : 8,
          animate: true,
          glowColor: ColorManager.green,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          child: SizedBox(
            width: 60.w,
            height: 60.w,
            child: FloatingActionButton(
              elevation: 50,
              backgroundColor: ColorManager.green,
              shape: const CircleBorder(),
              onPressed: _isProcessing ? null : _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none,
                  size: 30.w, color: ColorManager.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponseSection(ChatState state) {
    if (_isProcessing || state is ChatReceiverLoading) {
      return Card(
        color: ColorManager.grey.withOpacity(0.25),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Doctor AI Response:',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.grey),
                    onPressed: null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Skeletonizer(
                  enabled: true,
                  containersColor: ColorManager.grey.withOpacity(0.2),
                  effect: ShimmerEffect(
                    baseColor: ColorManager.grey.withOpacity(0.2),
                    highlightColor: ColorManager.grey.withOpacity(0.4),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            width: double.infinity,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    // If we have a response to display
    else if (_responseText.isNotEmpty) {
      return Card(
        color: ColorManager.grey.withOpacity(0.25),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' Doctor AI Response:',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        _isSpeaking ? Icons.volume_up : Icons.replay_rounded),
                    onPressed: () {
                      if (_isSpeaking) {
                        _stopSpeaking();
                      } else {
                        _speak(_responseText);
                      }
                    },
                    tooltip: _isSpeaking ? 'Stop speaking' : 'Speak response',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _responseText,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: _isArabic ? TextAlign.right : TextAlign.left,
                    textDirection:
                        _isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    // Empty state - no response yet
    else {
      return const SizedBox.shrink();
    }
  }
}
